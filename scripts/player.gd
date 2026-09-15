class_name Player
extends Unit

@export var move_enabled: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Aiming and arrow firing are implemented in Milestone 1.
		look_at(get_global_mouse_position())

func get_player_stats() -> Stats:
	return stats
