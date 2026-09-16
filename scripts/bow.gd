class_name Bow
extends Node2D

## Visual bow component. Gameplay values are supplied by BowData.

const STRING_REST_X: float = 18.0
const MAX_PULL: float = 24.0

@onready var string_top: Line2D = $StringTop
@onready var string_bottom: Line2D = $StringBottom
@onready var arrow_spawn: Marker2D = $ArrowSpawn

var data: BowData

func set_data(bow_data: BowData) -> void:
	data = bow_data
	set_draw_ratio(0.0)

func set_aim(angle: float) -> void:
	rotation = angle

func set_draw_ratio(ratio: float) -> void:
	var anchor_x: float = STRING_REST_X - MAX_PULL * clamp(ratio, 0.0, 1.0)
	string_top.points[1] = Vector2(anchor_x, 0.0)
	string_bottom.points[1] = Vector2(anchor_x, 0.0)

func get_arrow_spawn_position() -> Vector2:
	return arrow_spawn.global_position
