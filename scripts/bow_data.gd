class_name BowData
extends RefCounted

## Immutable-style definition for an equipment bow.
var id: String
var display_name: String
var price: int
var required_strength: int
var max_draw_strength: float
var draw_speed: float
var min_launch_speed: float
var max_launch_speed: float
var description: String

func _init(
	bow_id: String,
	name: String,
	cost: int,
	strength_requirement: int,
	max_draw: float,
	pull_speed: float,
	min_speed: float,
	max_speed: float,
	details: String
) -> void:
	id = bow_id
	display_name = name
	price = cost
	required_strength = strength_requirement
	max_draw_strength = max_draw
	draw_speed = pull_speed
	min_launch_speed = min_speed
	max_launch_speed = max_speed
	description = details
