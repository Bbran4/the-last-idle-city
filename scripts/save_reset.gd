extends Node

func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	if not event.pressed or event.echo:
		return
	if event.keycode != KEY_R or not event.ctrl_pressed or not event.shift_pressed:
		return

	SaveGame.delete_save()
	DirAccess.remove_absolute("user://range_progress.cfg")
	get_tree().reload_current_scene()
