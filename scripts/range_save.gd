class_name RangeSave
extends RefCounted

const SAVE_PATH: String = "user://range_progress.cfg"
const SAVE_SECTION: String = "range"
const RANGE_LEVEL_KEY: String = "level"

static func load_range_level(default_level: int, max_level: int) -> int:
	var data: Dictionary = SaveGame.load_data()
	if data.has("range_level"):
		return clamp(int(data["range_level"]), default_level, max_level)

	var config := ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return default_level
	var saved_level: int = int(config.get_value(SAVE_SECTION, RANGE_LEVEL_KEY, default_level))
	return clamp(saved_level, default_level, max_level)

static func save_range_level(level: int) -> bool:
	var data: Dictionary = SaveGame.load_data()
	data["range_level"] = level
	var save_ok: bool = SaveGame.save_data(data)
	if save_ok:
		DirAccess.remove_absolute(SAVE_PATH)
	return save_ok
