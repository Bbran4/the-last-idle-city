class_name Arrow
extends Node2D

signal hit_target(position: Vector2, target: Target, arrow: Arrow)
signal hit_dummy(position: Vector2, dummy: Area2D, arrow: Arrow)
signal missed
signal flight_segment(start: Vector2, end: Vector2, arrow: Arrow)

const GRAVITY: float = 2500.0
const POINT_SECTION_START: float = 28.0
const NOCK_SECTION_END: float = -34.0
const DUMMY_HIT_PADDING: float = 8.0

enum ArrowState {
	FLYING,
	EMBEDDED,
	KNOCKED_AWAY,
	BROKEN,
	FALLING
}

var velocity: Vector2 = Vector2.ZERO
var targets: Array[Target] = []
var passed_ring_targets: Array[Target] = []
var ground_y: float = 0.0
var window_left: float = 0.0
var window_right: float = 1280.0
var shot_origin: Vector2 = Vector2.ZERO
var state: ArrowState = ArrowState.FLYING
var embedded_target: Target = null
var embedded_position: Vector2 = Vector2.ZERO
var collision_dummy: Area2D = null

func launch(initial_velocity: Vector2, active_targets: Array[Target], ground: float, left_bound: float, right_bound: float, dummy: Area2D = null) -> void:
	velocity = initial_velocity
	targets = active_targets
	passed_ring_targets.clear()
	ground_y = ground
	window_left = left_bound
	window_right = right_bound
	shot_origin = position
	state = ArrowState.FLYING
	embedded_target = null
	embedded_position = Vector2.ZERO
	collision_dummy = dummy
	rotation = velocity.angle()
	queue_redraw()

func get_shot_distance_to_target(target: Target) -> float:
	if not is_instance_valid(target):
		return 0.0
	return shot_origin.distance_to(target.position)

func is_flying() -> bool:
	return state == ArrowState.FLYING

func is_embedded() -> bool:
	return state == ArrowState.EMBEDDED

func is_broken() -> bool:
	return state == ArrowState.BROKEN

func get_state() -> ArrowState:
	return state

func get_embedded_target() -> Target:
	return embedded_target

func get_section_at_local_position(local_position: Vector2) -> String:
	if local_position.x >= POINT_SECTION_START:
		return "point"
	if local_position.x <= NOCK_SECTION_END:
		return "nock"
	return "shaft"

func get_section_world_position(section: String) -> Vector2:
	var local_position: Vector2 = Vector2.ZERO
	match section:
		"point":
			local_position = Vector2(35.0, 0.0)
		"nock":
			local_position = Vector2(-39.0, 0.0)
		_:
			local_position = Vector2.ZERO
	return to_global(local_position)

func embed(target: Target = null, impact_position: Vector2 = Vector2.ZERO) -> void:
	state = ArrowState.EMBEDDED
	velocity = Vector2.ZERO
	embedded_target = target
	embedded_position = position if impact_position == Vector2.ZERO else impact_position
	queue_redraw()

func break_arrow() -> void:
	state = ArrowState.BROKEN
	velocity = Vector2.ZERO
	queue_redraw()

func knock_away(knock_velocity: Vector2) -> void:
	if state == ArrowState.BROKEN:
		return
	state = ArrowState.KNOCKED_AWAY
	embedded_target = null
	velocity = knock_velocity

func _process(delta: float) -> void:
	if state == ArrowState.EMBEDDED or state == ArrowState.BROKEN:
		return

	var previous_position: Vector2 = position
	var movement: Vector2 = velocity * delta
	position += movement
	velocity.y += GRAVITY * delta

	if velocity.length_squared() > 0.0:
		rotation = velocity.angle()

	if state == ArrowState.FLYING:
		var parent_node: Node2D = get_parent() as Node2D
		var global_previous_position: Vector2 = parent_node.to_global(previous_position) if parent_node != null else previous_position
		var global_position: Vector2 = parent_node.to_global(position) if parent_node != null else position
		flight_segment.emit(global_previous_position, global_position, self)
		if state != ArrowState.FLYING:
			return

		var ring_pass: Dictionary = _find_ring_pass(previous_position, position)
		if not ring_pass.is_empty():
			var ring_target: Target = ring_pass.target
			passed_ring_targets.append(ring_target)
			hit_target.emit(ring_pass.position, ring_target, self)

		var hit_target_result: Dictionary = _find_target_hit(previous_position, position)
		if not hit_target_result.is_empty():
			var target: Target = hit_target_result.target
			position = hit_target_result.position
			embed(target, position)
			hit_target.emit(position, target, self)
			return

		var dummy_hit: Vector2 = _find_dummy_hit(previous_position, position)
		if dummy_hit != Vector2.INF:
			position = dummy_hit
			embed(null, position)
			hit_dummy.emit(position, collision_dummy, self)
			return

	if _crossed_ground(previous_position, position):
		if position.x >= window_left and position.x <= window_right:
			position.y = ground_y
			embed()
			missed.emit()
			return
		missed.emit()
		queue_free()
		return

	queue_redraw()

func _crossed_ground(start: Vector2, end: Vector2) -> bool:
	return start.y < ground_y and end.y >= ground_y

func _find_ring_pass(start: Vector2, end: Vector2) -> Dictionary:
	var segment: Vector2 = end - start
	if abs(segment.x) <= 0.0001:
		return {}
	for target: Target in targets:
		if not is_instance_valid(target) or not target.visible or not target.is_ring_target:
			continue
		if passed_ring_targets.has(target):
			continue
		var t: float = (target.position.x - start.x) / segment.x
		if t < 0.0 or t > 1.0:
			continue
		var crossing: Vector2 = start + segment * t
		if abs(crossing.y - target.position.y) <= target.get_ring_inner_radius():
			return {"position": crossing, "target": target}
	return {}

func _find_target_hit(start: Vector2, end: Vector2) -> Dictionary:
	var closest_hit: Dictionary = {}
	var closest_projection: float = INF
	for target: Target in targets:
		if not is_instance_valid(target) or not target.visible or target.is_ring_target:
			continue
		var hit_position: Vector2 = _segment_circle_hit(start, end, target.position, target.get_radius())
		if hit_position == Vector2.INF:
			continue
		var segment: Vector2 = end - start
		var segment_length_squared: float = segment.length_squared()
		var projection: float = 0.0
		if segment_length_squared > 0.0:
			projection = clamp((hit_position - start).dot(segment) / segment_length_squared, 0.0, 1.0)
		if projection < closest_projection:
			closest_projection = projection
			closest_hit = {"position": hit_position, "target": target}
	return closest_hit

func _find_dummy_hit(start: Vector2, end: Vector2) -> Vector2:
	if not is_instance_valid(collision_dummy) or not collision_dummy.visible:
		return Vector2.INF
	var shape_node: CollisionShape2D = collision_dummy.get_node_or_null("CollisionShape2D") as CollisionShape2D
	if shape_node == null or shape_node.shape == null:
		return Vector2.INF
	var rect: Rect2 = shape_node.shape.get_rect()
	rect.position += collision_dummy.position + shape_node.position
	rect = rect.grow(DUMMY_HIT_PADDING)
	return _segment_rect_hit(start, end, rect)

func _segment_rect_hit(start: Vector2, end: Vector2, rect: Rect2) -> Vector2:
	if rect.has_point(start):
		return start
	var direction: Vector2 = end - start
	if direction.length_squared() <= 0.000001:
		return Vector2.INF
	var best_t: float = INF
	var best_point: Vector2 = Vector2.INF
	var edges: Array = [
		[Vector2(rect.position.x, rect.position.y), Vector2(rect.end.x, rect.position.y)],
		[Vector2(rect.end.x, rect.position.y), Vector2(rect.end.x, rect.end.y)],
		[Vector2(rect.end.x, rect.end.y), Vector2(rect.position.x, rect.end.y)],
		[Vector2(rect.position.x, rect.end.y), Vector2(rect.position.x, rect.position.y)]
	]
	for edge in edges:
		var hit: Dictionary = _segment_intersection(start, end, edge[0], edge[1])
		if not hit.is_empty() and hit.t < best_t:
			best_t = hit.t
			best_point = hit.position
	return best_point

func _segment_intersection(a: Vector2, b: Vector2, c: Vector2, d: Vector2) -> Dictionary:
	var r: Vector2 = b - a
	var s: Vector2 = d - c
	var denominator: float = r.cross(s)
	if abs(denominator) <= 0.000001:
		return {}
	var t: float = (c - a).cross(s) / denominator
	var u: float = (c - a).cross(r) / denominator
	if t < 0.0 or t > 1.0 or u < 0.0 or u > 1.0:
		return {}
	return {"t": t, "position": a + r * t}

func _segment_circle_hit(start: Vector2, end: Vector2, center: Vector2, radius: float) -> Vector2:
	var segment: Vector2 = end - start
	var segment_length_squared: float = segment.length_squared()
	if segment_length_squared <= 0.0:
		if start.distance_to(center) <= radius:
			return start
		return Vector2.INF

	var projection: float = clamp((center - start).dot(segment) / segment_length_squared, 0.0, 1.0)
	var closest: Vector2 = start + segment * projection
	if closest.distance_to(center) <= radius:
		return closest

	return Vector2.INF

func _draw() -> void:
	var arrow_rect: Rect2 = Rect2(-45.0, -5.0, 90.0, 10.0)
	draw_rect(arrow_rect, Color("d8d0bb"), true)
	draw_rect(arrow_rect, Color("8f988f"), false, 2.0)
	draw_colored_polygon(PackedVector2Array([
		Vector2(45.0, 0.0),
		Vector2(30.0, -9.0),
		Vector2(30.0, 9.0)
	]), Color("d7a449"))
