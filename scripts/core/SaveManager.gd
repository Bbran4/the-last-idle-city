class_name SaveManager
extends RefCounted

const SAVE_PATH := "user://savegame.json"


static func save_game() -> bool:
	var save_data := {
		"gold": GameState.data.gold,
		"game_time": GameState.data.game_time,
		"total_ticks": GameState.data.total_ticks
	}

	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)

	if file == null:
		push_error("Unable to open save file for writing.")
		return false

	file.store_string(JSON.stringify(save_data))
	file.close()

	return true


static func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)

	if file == null:
		push_error("Unable to open save file.")
		return false

	var json_text := file.get_as_text()
	file.close()

	var json := JSON.new()

	if json.parse(json_text) != OK:
		push_error("Save file contains invalid JSON.")
		return false

	var save_data = json.data

	if not save_data is Dictionary:
		push_error("Save data is not a Dictionary.")
		return false

	GameState.data.gold = float(save_data.get("gold", 0.0))
	GameState.data.game_time = float(save_data.get("game_time", 0.0))
	GameState.data.total_ticks = int(save_data.get("total_ticks", 0))

	return true
