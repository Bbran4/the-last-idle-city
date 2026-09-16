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

@onready var player: Player = $Player
@onready var target: Target = $Target
@onready var target_two: Target = $TargetTwo
@onready var target_three: Target = $TargetThree
@onready var ring_target: Target = $RingTarget
@onready var ground: Node2D = $Ground
@onready var range_decor: Node2D = $RangeDecor

var impact_position: Vector2 = Vector2.ZERO
var impact_timer: float = 0.0
var trajectory_angle: float = 0.0
var trajectory_speed: float = 0.0
var trajectory_draw_ratio: float = 0.0
var trajectory_quality: float = 0.0
var trajectory_visible: bool = false

func _ready() -> void:
	scale = Vector2.ONE * WORLD_SCALE
	set_active_targets(1)
	_update_camera()

func _process(_delta: float) -> void:
	_update_camera()
	queue_redraw()

func _update_camera() -> void:
	position.x = get_viewport_rect().size.x * 0.5 - player.position.x * WORLD_SCALE

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

func set_trajectory(angle: float, draw_ratio: float, launch_speed: float, quality: float, visible: bool) -> void:
	trajectory_angle = angle
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
	arrow.launch(
		direction * launch_speed,
		get_active_targets(),
		ground.position.y,
		0.0,
		to_local(Vector2(get_viewport_rect().size.x, 0.0)).x
	)
	return arrow

func get_active_targets() -> Array[Target]:
	var active: Array[Target] = []
	for range_target: Target in get_targets():
		if range_target.visible:
			active.append(range_target)
	return active

func clear_arrows() -> void:
	for child: Node in get_children():
		if child is Arrow:
			child.queue_free()

func _update_range_decor(range_level: int) -> void:
	range_decor.get_node("Level2").visible = range_level >= 2
	range_decor.get_node("Level3").visible = range_level >= 3
	range_decor.get_node("Level4").visible = range_level >= 4

func _draw() -> void:
	_draw_trajectory()
	if impact_timer <= 0.0:
		return
	var progress: float = 1.0 - impact_timer / IMPACT_FLASH_DURATION
	var radius: float = lerp(5.0, 14.0, progress)
	draw_circle(impact_position, radius, Color("d7a449"), false, 2.0 / WORLD_SCALE)
	draw_circle(impact_position, 2.0, Color("d7a449"))

func _draw_trajectory() -> void:
	if not trajectory_visible or trajectory_speed <= 0.0:
		return
	var origin: Vector2 = get_arrow_spawn_position()
	var velocity: Vector2 = Vector2.RIGHT.rotated(trajectory_angle) * trajectory_speed
	var prediction_time: float = min(TRAJECTORY_BASE_TIME + TRAJECTORY_EXTRA_TIME * trajectory_quality, TRAJECTORY_MAX_TIME)
	var points: PackedVector2Array = PackedVector2Array()
	var steps: int = maxi(2, ceili(prediction_time / TRAJECTORY_STEP))
	for index: int in range(steps + 1):
		var t: float = min(float(index) * TRAJECTORY_STEP, prediction_time)
		var point: Vector2 = origin + velocity * t + Vector2(0.0, 0.5 * GRAVITY * t * t)
		if point.y >= ground.position.y:
			break
		points.append(point)
	if points.size() < 2:
		return
	var line_width: float = lerp(2.0, 3.5, trajectory_quality)
	var alpha: float = lerp(0.30, 0.85, trajectory_quality)
	draw_polyline(points, Color(0.85, 0.82, 0.70, alpha), line_width, true)
	var final_point: Vector2 = points[points.size() - 1]
	draw_circle(final_point, lerp(3.0, 5.0, trajectory_quality), Color(0.85, 0.82, 0.70, alpha), false, line_width)
