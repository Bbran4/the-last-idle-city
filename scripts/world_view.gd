class_name WorldView
extends Node2D

## This node is scaled down so a wide practice range fits on screen. Its
## children (Ground, Player, Target) are real scene objects the user places
## in the editor -- this script no longer draws or positions any of them.
## It just reads their actual transforms/sizes and spawns arrows accordingly.

const WORLD_SCALE: float = 0.40
const ARROW_SCENE: PackedScene = preload("res://scenes/arrow.tscn")
const IMPACT_FLASH_DURATION: float = 0.18

@onready var player: Player = $Player
@onready var target: Target = $Target
@onready var ground: Node2D = $Ground

var impact_position: Vector2 = Vector2.ZERO
var impact_timer: float = 0.0

func _ready() -> void:
	scale = Vector2.ONE * WORLD_SCALE

func _process(_delta: float) -> void:
	queue_redraw()

## Converts a screen mouse position into this node's local ("world") space.
func get_world_mouse_position() -> Vector2:
	return to_local(get_viewport().get_mouse_position())

func get_bow_position() -> Vector2:
	return to_local(player.get_bow().global_position)

func aim_bow(angle: float) -> void:
	player.get_bow().set_aim(angle)

func set_draw_ratio(ratio: float) -> void:
	player.get_bow().set_draw_ratio(ratio)

func get_target() -> Target:
	return target

func update_impact(position: Vector2, timer: float) -> void:
	impact_position = position
	impact_timer = timer

## Spawns an arrow at wherever the bow's ArrowSpawn marker currently is
## (which already accounts for the bow's aim rotation), aimed at wherever
## the Target and Ground nodes actually sit in the scene.
func fire_arrow(direction: Vector2, launch_speed: float) -> Arrow:
	var bow: Bow = player.get_bow()
	var arrow: Arrow = ARROW_SCENE.instantiate() as Arrow
	arrow.position = to_local(bow.get_arrow_spawn_position())
	add_child(arrow)
	arrow.launch(
		direction * launch_speed,
		target.position,
		target.get_radius(),
		ground.position.y,
		0.0,
		to_local(Vector2(get_viewport_rect().size.x, 0.0)).x
	)
	return arrow

func clear_arrows() -> void:
	for child: Node in get_children():
		if child is Arrow:
			child.queue_free()

func _draw() -> void:
	if impact_timer <= 0.0:
		return
	var progress: float = 1.0 - impact_timer / IMPACT_FLASH_DURATION
	var radius: float = lerp(5.0, 14.0, progress)
	draw_circle(impact_position, radius, Color("d7a449"), false, 2.0 / WORLD_SCALE)
	draw_circle(impact_position, 2.0, Color("d7a449"))
