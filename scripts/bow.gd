class_name Bow
extends Node2D

## Visual bow component. Gameplay values are supplied by BowData.

const STRING_REST_X: float = 18.0
const MAX_PULL: float = 24.0

@onready var limb: Line2D = $Limb
@onready var string_top: Line2D = $StringTop
@onready var string_bottom: Line2D = $StringBottom
@onready var arrow_spawn: Marker2D = $ArrowSpawn

var data: BowData

func set_data(bow_data: BowData) -> void:
	data = bow_data
	_apply_visual_data()
	set_draw_ratio(0.0)

func _apply_visual_data() -> void:
	if data == null:
		return
	limb.default_color = data.limb_color
	limb.width = data.limb_width
	limb.points = PackedVector2Array([
		Vector2(0.0, -data.limb_height),
		Vector2(0.0, data.limb_height)
	])
	string_top.default_color = data.string_color
	string_bottom.default_color = data.string_color
	string_top.width = data.string_width
	string_bottom.width = data.string_width
	arrow_spawn.position.x = data.arrow_spawn_offset

func set_aim(angle: float) -> void:
	rotation = angle

func set_draw_ratio(ratio: float) -> void:
	var anchor_x: float = STRING_REST_X - MAX_PULL * clamp(ratio, 0.0, 1.0)
	string_top.points[1] = Vector2(anchor_x, 0.0)
	string_bottom.points[1] = Vector2(anchor_x, 0.0)

func get_arrow_spawn_position() -> Vector2:
	return arrow_spawn.global_position
