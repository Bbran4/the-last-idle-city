class_name RangeSave
extends RefCounted

const SAVE_PATH: String = "user://range_progress.cfg"
const SAVE_SECTION: String = "range"
const RANGE_LEVEL_KEY: String = "level"

static func load_range_level(default_level: int, max_level: int) -> int:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return default_level
	var saved_level: int = int(config.get_value(SAVE_SECTION, RANGE_LEVEL_KEY, default_level))
	return clamp(saved_level, default_level, max_level)

static func save_range_level(level: int) -> bool:
	var config := ConfigFile.new()
	var load_result: int = config.load(SAVE_PATH)
	if load_result != OK and load_result != ERR_FILE_NOT_FOUND:
		return false
	config.set_value(SAVE_SECTION, RANGE_LEVEL_KEY, level)
	return config.save(SAVE_PATH) == OK
