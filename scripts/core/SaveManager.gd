class_name SaveManager
extends RefCounted

const SAVE_PATH: String = "user://savegame.json"

static func save_game() -> bool:
	var data: GameData = GameState.data
	var department_data: Dictionary = {}
	for department in GameState.departments:
		department_data[department.department_name] = department.save_data()

	var save_data: Dictionary = {
		"materials": data.materials.to_dict(),
		"total_materials_produced": data.total_materials_produced.to_dict(),
		"energy": data.energy,
		"population": data.population,
		"industrial_authority_allocation": data.industrial_authority_allocation,
		"game_time": data.game_time,
		"total_ticks": data.total_ticks,
		"departments": department_data
	}
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Unable to open save file for writing.")
		return false
	file.store_string(JSON.stringify(save_data))
	file.close()
	return true

static func _load_big_number(value: Variant, fallback: BigNumber) -> BigNumber:
	if value is Dictionary:
		return BigNumber.from_dict(value)
	if value is float or value is int:
		return BigNumber.from_float(float(value))
	return fallback

static func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_error("Unable to open save file.")
		return false
	var json: JSON = JSON.new()
	if json.parse(file.get_as_text()) != OK:
		file.close()
		push_error("Save file contains invalid JSON.")
		return false
	file.close()
	var save_data: Variant = json.data
	if not save_data is Dictionary:
		push_error("Save data is not a Dictionary.")
		return false

	var data: GameData = GameState.data
	data.materials = _load_big_number(save_data.get("materials", 0.0), BigNumber.zero())
	data.total_materials_produced = _load_big_number(save_data.get("total_materials_produced", null), data.materials)
	data.energy = max(0.0, float(save_data.get("energy", GameData.STARTING_ENERGY)))
	data.population = max(0.0, float(save_data.get("population", GameData.STARTING_POPULATION)))
	data.set_industrial_authority_allocation(float(save_data.get("industrial_authority_allocation", 50.0)))
	data.game_time = float(save_data.get("game_time", 0.0))
	data.total_ticks = int(save_data.get("total_ticks", 0))

	var department_data: Variant = save_data.get("departments", {})
	if department_data is Dictionary:
		for department in GameState.departments:
			if department_data.has(department.department_name):
				department.load_save_data(department_data[department.department_name])

	return true
