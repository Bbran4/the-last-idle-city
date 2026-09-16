class_name Arrow
extends Node2D

signal hit_target(position: Vector2, target: Target)
signal missed

const GRAVITY: float = 180.0

var velocity: Vector2 = Vector2.ZERO
var targets: Array[Target] = []
var ground_y: float = 0.0
var window_left: float = 0.0
var window_right: float = 1280.0
var is_embedded: bool = false

func launch(initial_velocity: Vector2, active_targets: Array[Target], ground: float, left_bound: float, right_bound: float) -> void:
	velocity = initial_velocity
	targets = active_targets
	ground_y = ground
	window_left = left_bound
	window_right = right_bound
	is_embedded = false
	rotation = velocity.angle()
	queue_redraw()

func _process(delta: float) -> void:
	if is_embedded:
		return

	var previous_position: Vector2 = position
	var movement: Vector2 = velocity * delta
	position += movement
	velocity.y += GRAVITY * delta

	if velocity.length_squared() > 0.0:
		rotation = velocity.angle()

	var hit_target_result: Dictionary = _find_target_hit(previous_position, position)
	if not hit_target_result.is_empty():
		var target: Target = hit_target_result.target
		position = hit_target_result.position
		embed()
		hit_target.emit(position, target)
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

func embed() -> void:
	is_embedded = true
	velocity = Vector2.ZERO
	queue_redraw()

func _find_target_hit(start: Vector2, end: Vector2) -> Dictionary:
	var closest_hit: Dictionary = {}
	var closest_projection: float = INF
	for target: Target in targets:
		if not is_instance_valid(target) or not target.visible:
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
