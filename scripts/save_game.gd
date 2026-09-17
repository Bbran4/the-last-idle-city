class_name SaveGame
extends RefCounted

const SAVE_PATH: String = "user://player_progress.cfg"
const SAVE_VERSION: int = 1

static func load_data() -> Dictionary:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return {}
	var data: Dictionary = config.get_value("save", "data", {})
	if not data is Dictionary:
		return {}
	return data

static func save_data(data: Dictionary) -> bool:
	var config := ConfigFile.new()
	config.set_value("save", "version", SAVE_VERSION)
	config.set_value("save", "data", data)
	return config.save(SAVE_PATH) == OK

static func delete_save() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return true
	return DirAccess.remove_absolute(SAVE_PATH) == OK
