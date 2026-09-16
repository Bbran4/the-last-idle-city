class_name Bow
extends Node2D

## The bow's own rotation IS the aim direction, and the arrow spawn marker
## sits in front of it along local +X -- so aiming and firing automatically
## stay correct no matter how this bow is positioned or nested in a scene.

const STRING_REST_X: float = 18.0
const MAX_PULL: float = 24.0

@onready var string_top: Line2D = $StringTop
@onready var string_bottom: Line2D = $StringBottom
@onready var arrow_spawn: Marker2D = $ArrowSpawn

func set_aim(angle: float) -> void:
	rotation = angle

func set_draw_ratio(ratio: float) -> void:
	var anchor_x: float = STRING_REST_X - MAX_PULL * clamp(ratio, 0.0, 1.0)
	string_top.points[1] = Vector2(anchor_x, 0.0)
	string_bottom.points[1] = Vector2(anchor_x, 0.0)

func get_arrow_spawn_position() -> Vector2:
	return arrow_spawn.global_position
