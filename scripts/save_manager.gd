extends Node

const SAVE_PATH: String = "user://player_progress.cfg"
const LEGACY_RANGE_SAVE_PATH: String = "user://range_progress.cfg"
const SAVE_VERSION: int = 1
const RANGE_LEVEL_KEY: String = "range_level"

func load_data() -> Dictionary:
	var config: ConfigFile = ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return {}
	var data: Variant = config.get_value("save", "data", {})
	if not data is Dictionary:
		return {}
	return data as Dictionary

func save_data(data: Dictionary) -> bool:
	var config: ConfigFile = ConfigFile.new()
	config.set_value("save", "version", SAVE_VERSION)
	config.set_value("save", "data", data)
	return config.save(SAVE_PATH) == OK

func delete_save() -> bool:
	var save_removed: bool = true
	var legacy_removed: bool = true
	if FileAccess.file_exists(SAVE_PATH):
		save_removed = DirAccess.remove_absolute(SAVE_PATH) == OK
	if FileAccess.file_exists(LEGACY_RANGE_SAVE_PATH):
		legacy_removed = DirAccess.remove_absolute(LEGACY_RANGE_SAVE_PATH) == OK
	return save_removed and legacy_removed

func load_range_level(default_level: int, max_level: int) -> int:
	var data: Dictionary = load_data()
	if data.has(RANGE_LEVEL_KEY):
		return clampi(int(data[RANGE_LEVEL_KEY]), default_level, max_level)

	var legacy_level: int = _load_legacy_range_level(default_level)
	if legacy_level != default_level or FileAccess.file_exists(LEGACY_RANGE_SAVE_PATH):
		data[RANGE_LEVEL_KEY] = legacy_level
		save_data(data)
		if FileAccess.file_exists(LEGACY_RANGE_SAVE_PATH):
			DirAccess.remove_absolute(LEGACY_RANGE_SAVE_PATH)
	return legacy_level

func save_range_level(level: int) -> bool:
	var data: Dictionary = load_data()
	data[RANGE_LEVEL_KEY] = level
	return save_data(data)

func _load_legacy_range_level(default_level: int) -> int:
	var config: ConfigFile = ConfigFile.new()
	if config.load(LEGACY_RANGE_SAVE_PATH) != OK:
		return default_level
	var saved_level: int = int(config.get_value("range", "level", default_level))
	return max(saved_level, default_level)

func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	if not event.pressed or event.echo:
		return
	if event.keycode != KEY_R or not event.ctrl_pressed or not event.shift_pressed:
		return
	delete_save()
	get_tree().reload_current_scene()
