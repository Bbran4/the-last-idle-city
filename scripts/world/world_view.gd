class_name WorldView
extends Node2D

## World-space practice range and projectile visualization.

const WORLD_SCALE: float = 0.40
const ARROW_SCENE: PackedScene = preload("res://scenes/arrow.tscn")
const IMPACT_FLASH_DURATION: float = 0.18
const GRAVITY: float = 2500.0
const TRAJECTORY_STEP: float = 0.055
const TRAJECTORY_MAX_TIME: float = 4.0
const TRAJECTORY_BASE_TIME: float = 0.65
const TRAJECTORY_EXTRA_TIME: float = 2.75
# The nock itself is only a small section at the rear of the arrow. Keep this
# radius tight so a shot must actually pass over the nock instead of merely
# flying nearby.
const NOCK_HIT_RADIUS: float = 4.0
const MID_AIR_ARROW_RADIUS: float = 7.0
const MID_AIR_KNOCKBACK: float = 0.35
const MID_AIR_STRUCK_PUSH: float = 120.0
const MID_AIR_STRUCK_PUSH_SCALE: float = 0.45
const MID_AIR_INCOMING_RETENTION: float = 0.55
const MID_AIR_INCOMING_PUSH: float = 80.0
const MID_AIR_INCOMING_PUSH_SCALE: float = 0.35

const TRAIL_MAX_POINTS: int = 14
const TRAIL_COLOR: Color = Color("d8d0bb")
const CAMERA_SMOOTHING: float = 8.0

@onready var player: Player = $Player
@onready var target: Target = $TrainingGrounds/PracticeTargets/Target
@onready var target_two: Target = $TrainingGrounds/PracticeTargets/TargetTwo
@onready var target_three: Target = $TrainingGrounds/PracticeTargets/TargetThree
@onready var ring_target: Target = $TrainingGrounds/PracticeTargets/RingTarget
@onready var training_dummy: Area2D = $TrainingGrounds/TrainingDummy
@onready var ground: Node2D = $Ground
@onready var range_decor: Node2D = $RangeDecor

var camera_base_x: float = 0.0
var shake_timer: float = 0.0
var shake_duration: float = 0.0
var shake_strength: float = 0.0
var shake_offset: Vector2 = Vector2.ZERO
var arrow_trails: Dictionary = {}

var impact_position: Vector2 = Vector2.ZERO
var impact_timer: float = 0.0
var trajectory_direction: Vector2 = Vector2.RIGHT
var trajectory_speed: float = 0.0
var trajectory_draw_ratio: float = 0.0
var trajectory_quality: float = 0.0
var trajectory_visible: bool = false
var arrows: Array[Arrow] = []

func _ready() -> void:
	scale = Vector2.ONE * WORLD_SCALE
	set_active_targets(1)
	camera_base_x = get_viewport_rect().size.x * 0.5 - player.position.x * WORLD_SCALE
	position = Vector2(camera_base_x, 0.0)

func _process(delta: float) -> void:
	_update_arrow_trails()
	_cleanup_arrows()
	_update_camera(delta)
	_update_shake(delta)
	queue_redraw()

func _update_arrow_trails() -> void:
	for arrow in get_arrows():
		if not is_instance_valid(arrow):
			continue
		if arrow.is_embedded() or arrow.is_broken():
			arrow_trails.erase(arrow)
			continue
		var local_point: Vector2 = to_local(arrow.global_position)
		var trail: PackedVector2Array = arrow_trails.get(arrow, PackedVector2Array())
		trail.append(local_point)
		if trail.size() > TRAIL_MAX_POINTS:
			trail.remove_at(0)
		arrow_trails[arrow] = trail

func _update_camera(delta: float) -> void:
	var target_x: float = get_viewport_rect().size.x * 0.5 - player.position.x * WORLD_SCALE
	camera_base_x = lerp(camera_base_x, target_x, 1.0 - exp(-CAMERA_SMOOTHING * delta))
	position = Vector2(camera_base_x, 0.0) + shake_offset

func _update_shake(delta: float) -> void:
	if shake_timer > 0.0:
		shake_timer = max(shake_timer - delta, 0.0)
		var falloff: float = shake_timer / shake_duration if shake_duration > 0.0 else 0.0
		shake_offset = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * shake_strength * falloff
	else:
		shake_offset = Vector2.ZERO

func trigger_shake(strength: float, duration: float) -> void:
	shake_strength = strength
	shake_duration = duration
	shake_timer = duration

func play_bow_recoil() -> void:
	player.get_bow().play_release_recoil()

func get_world_mouse_position() -> Vector2:
	return to_local(get_viewport().get_mouse_position())

func get_bow_position() -> Vector2:
	return to_local(player.get_bow().global_position)

func get_arrow_spawn_position() -> Vector2:
	return to_local(player.get_bow().get_arrow_spawn_position())

func aim_bow(angle: float) -> void:
	player.get_bow().set_aim(angle)

func configure_bow(data: BowData) -> void:
	player.get_bow().set_data(data)

func set_draw_ratio(ratio: float) -> void:
	player.get_bow().set_draw_ratio(ratio)

func set_recovery_progress(progress: float) -> void:
	player.set_recovery_progress(progress)

func set_trajectory(direction: Vector2, draw_ratio: float, launch_speed: float, quality: float, visible: bool) -> void:
	trajectory_direction = direction.normalized() if direction.length_squared() > 0.000001 else Vector2.RIGHT
	trajectory_draw_ratio = clamp(draw_ratio, 0.0, 1.0)
	trajectory_speed = max(launch_speed, 0.0)
	trajectory_quality = clamp(quality, 0.0, 1.0)
	trajectory_visible = visible and trajectory_draw_ratio > 0.0
	queue_redraw()

func get_target() -> Target:
	return target

func get_targets() -> Array[Target]:
	return [target, target_two, target_three, ring_target]

func set_active_targets(range_level: int) -> void:
	var targets: Array[Target] = get_targets()
	for index: int in range(targets.size()):
		targets[index].visible = index < range_level
	training_dummy.visible = range_level >= 3
	_update_range_decor(range_level)

func set_range_level(level: int) -> void:
	set_active_targets(level)

func get_range_level() -> int:
	var active_targets: Array[Target] = get_active_targets()
	return active_targets.size()

func get_range_upgrade_costs() -> Array[int]:
	return [50, 100, 250]

func update_impact(position: Vector2, timer: float) -> void:
	impact_position = position
	impact_timer = timer

func fire_arrow(direction: Vector2, launch_speed: float) -> Arrow:
	var bow: Bow = player.get_bow()
	var arrow: Arrow = ARROW_SCENE.instantiate() as Arrow
	arrow.position = to_local(bow.get_arrow_spawn_position())
	add_child(arrow)
	arrows.append(arrow)
	arrow.tree_exited.connect(_on_arrow_tree_exited.bind(arrow), CONNECT_ONE_SHOT)
	arrow.flight_segment.connect(_on_arrow_flight_segment)
	arrow.launch(
		direction * launch_speed,
		get_active_targets(),
		player.position.y,
		0.0,
		to_local(Vector2(get_viewport_rect().size.x, 0.0)).x,
		training_dummy if training_dummy.visible else null
	)
	return arrow

func get_active_targets() -> Array[Target]:
	var active: Array[Target] = []
	for range_target: Target in get_targets():
		if range_target.visible:
			active.append(range_target)
	return active

func get_arrows() -> Array[Arrow]:
	_cleanup_arrows()
	return arrows.duplicate()

func get_embedded_arrows() -> Array[Arrow]:
	var embedded: Array[Arrow] = []
	for arrow: Arrow in arrows:
		if is_instance_valid(arrow) and arrow.is_embedded():
			embedded.append(arrow)
	return embedded

func clear_arrows() -> void:
	for arrow: Arrow in arrows:
		if is_instance_valid(arrow):
			arrow.queue_free()
	arrows.clear()

func _cleanup_arrows() -> void:
	for index: int in range(arrows.size() - 1, -1, -1):
		if not is_instance_valid(arrows[index]):
			arrows.remove_at(index)

func _record_trail_point(arrow: Arrow, global_point: Vector2) -> void:
	var local_point: Vector2 = to_local(global_point)
	var trail: PackedVector2Array = arrow_trails.get(arrow, PackedVector2Array())
	trail.append(local_point)
	if trail.size() > TRAIL_MAX_POINTS:
		trail.remove_at(0)
	arrow_trails[arrow] = trail

func _on_arrow_tree_exited(arrow: Arrow) -> void:
	arrows.erase(arrow)
	arrow_trails.erase(arrow)

func _on_arrow_flight_segment(start: Vector2, end: Vector2, incoming_arrow: Arrow) -> void:
	if not is_instance_valid(incoming_arrow) or not incoming_arrow.is_flying():
		return

	var embedded_arrow: Arrow = _find_nock_hit(start, end, incoming_arrow)
	if is_instance_valid(embedded_arrow):
		embedded_arrow.break_arrow()
		embedded_arrow.queue_free()
		return

	var struck_arrow: Arrow = _find_flying_arrow_hit(start, end, incoming_arrow)
	if is_instance_valid(struck_arrow):
		var incoming_velocity: Vector2 = incoming_arrow.velocity
		var struck_velocity: Vector2 = struck_arrow.velocity
		var collision_direction: Vector2 = (struck_arrow.global_position - incoming_arrow.global_position).normalized()
		if collision_direction == Vector2.ZERO:
			collision_direction = Vector2.UP
		var struck_knock_velocity: Vector2 = incoming_velocity * MID_AIR_KNOCKBACK + collision_direction * max(incoming_velocity.length() * MID_AIR_STRUCK_PUSH_SCALE, MID_AIR_STRUCK_PUSH)
		var incoming_knock_velocity: Vector2 = incoming_velocity * MID_AIR_INCOMING_RETENTION - collision_direction * max(struck_velocity.length() * MID_AIR_INCOMING_PUSH_SCALE, MID_AIR_INCOMING_PUSH)
		struck_arrow.knock_away(struck_knock_velocity)
		incoming_arrow.knock_away(incoming_knock_velocity)

func _find_nock_hit(start: Vector2, end: Vector2, incoming_arrow: Arrow) -> Arrow:
	var closest_arrow: Arrow = null
	var closest_projection: float = INF
	for embedded_arrow: Arrow in get_embedded_arrows():
		if embedded_arrow == incoming_arrow:
			continue
		var embedded_target: Target = embedded_arrow.get_embedded_target()
		var embedded_dummy: Area2D = embedded_arrow.get_embedded_dummy()
		if not embedded_arrow.is_embedded():
			continue
		if not is_instance_valid(embedded_target) and not is_instance_valid(embedded_dummy):
			continue
		var nock_position: Vector2 = embedded_arrow.get_section_world_position("nock")
		var projection: float = _segment_point_projection(start, end, nock_position)
		if projection < 0.0 or projection > 1.0:
			continue
		var closest_point: Vector2 = start.lerp(end, projection)
		if closest_point.distance_to(nock_position) > NOCK_HIT_RADIUS:
			continue
		if projection < closest_projection:
			closest_projection = projection
			closest_arrow = embedded_arrow
	return closest_arrow

func _find_flying_arrow_hit(start: Vector2, end: Vector2, incoming_arrow: Arrow) -> Arrow:
	var closest_arrow: Arrow = null
	var closest_projection: float = INF
	for other_arrow: Arrow in get_arrows():
		if other_arrow == incoming_arrow or not other_arrow.is_flying():
			continue
		var other_point: Vector2 = other_arrow.get_section_world_position("point")
		var other_nock: Vector2 = other_arrow.get_section_world_position("nock")
		var collision: Dictionary = _segment_segment_closest_points(start, end, other_nock, other_point)
		if collision.is_empty() or collision.distance > MID_AIR_ARROW_RADIUS:
			continue
		if collision.incoming_projection < closest_projection:
			closest_projection = collision.incoming_projection
			closest_arrow = other_arrow
	return closest_arrow

func _segment_point_projection(start: Vector2, end: Vector2, point: Vector2) -> float:
	var segment: Vector2 = end - start
	var length_squared: float = segment.length_squared()
	if length_squared <= 0.0:
		return 0.0
	return clamp((point - start).dot(segment) / length_squared, 0.0, 1.0)

func _segment_segment_closest_points(start_a: Vector2, end_a: Vector2, start_b: Vector2, end_b: Vector2) -> Dictionary:
	var direction_a: Vector2 = end_a - start_a
	var direction_b: Vector2 = end_b - start_b
	var offset: Vector2 = start_a - start_b
	var length_a: float = direction_a.length_squared()
	var length_b: float = direction_b.length_squared()
	if length_a <= 0.000001 and length_b <= 0.000001:
		return {"distance": start_a.distance_to(start_b), "incoming_projection": 0.0}
	if length_a <= 0.000001:
		var projection_b: float = clamp((start_a - start_b).dot(direction_b) / length_b, 0.0, 1.0)
		return {"distance": start_a.distance_to(start_b.lerp(end_b, projection_b)), "incoming_projection": 0.0}
	if length_b <= 0.000001:
		var projection_a: float = clamp((start_b - start_a).dot(direction_a) / length_a, 0.0, 1.0)
		return {"distance": start_b.distance_to(start_a.lerp(end_a, projection_a)), "incoming_projection": projection_a}
	var a_dot_b: float = direction_a.dot(direction_b)
	var a_dot_offset: float = direction_a.dot(offset)
	var b_dot_offset: float = direction_b.dot(offset)
	var denominator: float = length_a * length_b - a_dot_b * a_dot_b
	var projection_a: float
	var projection_b: float
	if abs(denominator) <= 0.000001:
		projection_a = 0.0
		projection_b = clamp(b_dot_offset / length_b, 0.0, 1.0)
	else:
		projection_a = clamp((a_dot_b * b_dot_offset - a_dot_offset * length_b) / denominator, 0.0, 1.0)
		projection_b = clamp((a_dot_b * projection_a + b_dot_offset) / length_b, 0.0, 1.0)
	var point_a: Vector2 = start_a.lerp(end_a, projection_a)
	var point_b: Vector2 = start_b.lerp(end_b, projection_b)
	return {"distance": point_a.distance_to(point_b), "incoming_projection": projection_a}

func _update_range_decor(range_level: int) -> void:
	range_decor.get_node("Level2").visible = range_level >= 2
	range_decor.get_node("Level3").visible = range_level >= 3
	range_decor.get_node("Level4").visible = range_level >= 4

func _draw() -> void:
	_draw_arrow_trails()
	_draw_trajectory()
	if impact_timer <= 0.0:
		return
	var progress: float = 1.0 - impact_timer / IMPACT_FLASH_DURATION
	var radius: float = lerp(5.0, 14.0, progress)
	draw_circle(impact_position, radius, Color("d7a449"), false, 2.0 / WORLD_SCALE)
	draw_circle(impact_position, 2.0, Color("d7a449"))

func _draw_arrow_trails() -> void:
	for arrow in arrow_trails.keys():
		var trail: PackedVector2Array = arrow_trails[arrow]
		if trail.size() < 2:
			continue
		for i in range(trail.size() - 1):
			var t: float = float(i) / float(trail.size() - 1)
			draw_line(trail[i], trail[i + 1], Color(TRAIL_COLOR.r, TRAIL_COLOR.g, TRAIL_COLOR.b, t * 0.5), lerp(1.0, 3.0, t))
		
func _draw_trajectory() -> void:
	if not trajectory_visible or trajectory_speed <= 0.0:
		return
	var origin: Vector2 = get_arrow_spawn_position()
	var velocity: Vector2 = trajectory_direction * trajectory_speed
	var prediction_time: float = min(TRAJECTORY_BASE_TIME + TRAJECTORY_EXTRA_TIME * trajectory_quality, TRAJECTORY_MAX_TIME)
	var points: PackedVector2Array = PackedVector2Array()
	var steps: int = maxi(2, ceili(prediction_time / TRAJECTORY_STEP))
	for index: int in range(steps + 1):
		var t: float = minf(float(index) * TRAJECTORY_STEP, prediction_time)
		var point: Vector2 = origin + velocity * t + Vector2(0.0, 0.5 * GRAVITY * t * t)
		if point.y >= player.position.y:
			var previous_point: Vector2 = origin
			if points.size() > 0:
				previous_point = points[points.size() - 1]
			var ground_delta: float = point.y - previous_point.y
			if absf(ground_delta) > 0.000001:
				var ground_t: float = clampf((player.position.y - previous_point.y) / ground_delta, 0.0, 1.0)
				points.append(previous_point.lerp(point, ground_t))
			else:
				points.append(point)
			break
		points.append(point)
	if points.size() < 2:
		return
	var line_width: float = lerp(2.0, 3.5, trajectory_quality)
	var alpha: float = lerp(0.30, 0.85, trajectory_quality)
	draw_polyline(points, Color(0.85, 0.82, 0.70, alpha), line_width, true)
	var final_point: Vector2 = points[points.size() - 1]
	draw_circle(final_point, lerp(3.0, 5.0, trajectory_quality), Color(0.85, 0.82, 0.70, alpha), false, line_width)
