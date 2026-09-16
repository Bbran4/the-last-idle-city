class_name WorldView
extends Node2D

## Owns everything that lives in "world space" (the archer, bow, target,
## ground, and arrows). This node itself is scaled down by WORLD_SCALE, so
## anything positioned in world-space coordinates and parented under it
## (including Arrow instances) is automatically placed and sized correctly
## on screen -- no manual *WORLD_SCALE / WORLD_SCALE math needed anywhere else.

const WORLD_SCALE: float = 0.40
const ARROW_SCENE: PackedScene = preload("res://scenes/arrow.tscn")

const PLAYER_POSITION: Vector2 = Vector2(350.0, 500.0)
const BOW_POSITION: Vector2 = Vector2(405.0, 455.0)
const TARGET_POSITION: Vector2 = Vector2(2200.0, 400.0)
const TARGET_RADIUS: float = 100.0
const GROUND_Y: float = 1250.0

var aim_angle: float = 0.0
var draw_strength: float = 0.0
var max_draw_strength: float = 1.0
var is_drawing: bool = false

var impact_position: Vector2 = Vector2.ZERO
var impact_timer: float = 0.0
const IMPACT_FLASH_DURATION: float = 0.18

func _ready() -> void:
	scale = Vector2.ONE * WORLD_SCALE
	queue_redraw()

func _process(_delta: float) -> void:
	queue_redraw()

func update_aim_state(new_aim_angle: float, new_draw_strength: float, new_max_draw_strength: float, drawing: bool) -> void:
	aim_angle = new_aim_angle
	draw_strength = new_draw_strength
	max_draw_strength = new_max_draw_strength
	is_drawing = drawing

func update_impact(position: Vector2, timer: float) -> void:
	impact_position = position
	impact_timer = timer

## Spawns an arrow at the bow, in world-space coordinates, as a CHILD of
## this scaled node -- so its position and visuals both come out correct
## on screen automatically, and its collision math (already written in
## consistent world units) lines up with where things are actually drawn.
func fire_arrow(direction: Vector2, launch_speed: float) -> Arrow:
	var arrow: Arrow = ARROW_SCENE.instantiate() as Arrow
	arrow.position = BOW_POSITION + direction * 28.0
	add_child(arrow)
	arrow.launch(
		direction * launch_speed,
		TARGET_POSITION,
		TARGET_RADIUS,
		GROUND_Y,
		0.0,
		get_viewport_rect().size.x / WORLD_SCALE
	)
	return arrow

func clear_arrows() -> void:
	for child: Node in get_children():
		if child is Arrow:
			child.queue_free()

func _draw() -> void:
	var viewport_size: Vector2 = get_viewport_rect().size / WORLD_SCALE

	draw_rect(Rect2(Vector2(0.0, GROUND_Y), Vector2(viewport_size.x, viewport_size.y - GROUND_Y)), Color("293126"))
	draw_line(Vector2(0.0, GROUND_Y), Vector2(viewport_size.x, GROUND_Y), Color("4d5948"), 2.0 / WORLD_SCALE)

	_draw_player(PLAYER_POSITION)
	_draw_bow(BOW_POSITION)
	_draw_target(TARGET_POSITION)
	_draw_impact()

func _draw_player(world_position: Vector2) -> void:
	var size: Vector2 = Vector2(100.0, 120.0)
	var rect: Rect2 = Rect2(world_position - Vector2(size.x * 0.5, size.y), size)
	draw_rect(rect, Color("6d7f91"), true)
	draw_rect(rect, Color("aeb8c0"), false, 2.0 / WORLD_SCALE)

func _draw_bow(world_position: Vector2) -> void:
	var direction: Vector2 = Vector2.RIGHT.rotated(aim_angle)
	var perpendicular: Vector2 = direction.rotated(PI * 0.5)
	var bow_length: float = 70.0
	var top: Vector2 = world_position + perpendicular * bow_length
	var bottom: Vector2 = world_position - perpendicular * bow_length
	var string_rest: Vector2 = world_position + direction * 18.0
	var pull_distance: float = 24.0 * (draw_strength / max_draw_strength)
	var string_anchor: Vector2 = string_rest - direction * pull_distance

	draw_line(top, bottom, Color("8d603d"), 4.0 / WORLD_SCALE)
	draw_line(top, string_anchor, Color("d8d0bb"), 1.5 / WORLD_SCALE)
	draw_line(string_anchor, bottom, Color("d8d0bb"), 1.5 / WORLD_SCALE)

	if is_drawing:
		draw_circle(string_anchor, 3.0, Color("d7a449"))

func _draw_target(world_position: Vector2) -> void:
	var radius: float = TARGET_RADIUS
	draw_circle(world_position, radius, Color("ded6c4"))
	draw_circle(world_position, radius * 0.72, Color("8d4437"))
	draw_circle(world_position, radius * 0.52, Color("ded6c4"))
	draw_circle(world_position, radius * 0.32, Color("8d4437"))
	draw_circle(world_position, radius * 0.16, Color("d7a449"))

func _draw_impact() -> void:
	if impact_timer <= 0.0:
		return

	var progress: float = 1.0 - impact_timer / IMPACT_FLASH_DURATION
	var radius: float = lerp(5.0, 14.0, progress)
	draw_circle(impact_position, radius, Color("d7a449"), false, 2.0 / WORLD_SCALE)
	draw_circle(impact_position, 2.0, Color("d7a449"))
