class_name SaveManager
extends RefCounted

const SAVE_PATH: String = "user://savegame.json"

static func save_game() -> bool:
	var data: GameData = GameState.data
	var save_data: Dictionary = {
		"materials": data.materials.to_dict(),
		"scrap_yard": data.scrap_yard.save_data(),
		"population": data.population,
		"industrial_allocation_percent": data.industrial_allocation_percent,
		"civilian_allocation_percent": data.civilian_allocation_percent,
		"security_allocation_percent": data.security_allocation_percent,
		"scientific_allocation_percent": data.scientific_allocation_percent,
		"energy": data.energy,
		"energy_priority": data.energy_priority,
		"reclamation_depot": data.reclamation_depot.save_data(),
		"workshop": data.workshop.save_data(),
		"factory": data.factory.save_data(),
		"total_materials_produced": data.total_materials_produced.to_dict(),
		"scrap_yard_level_automation_progress": data.scrap_yard_level_automation_progress,
		"reclamation_depot_level_automation_progress": data.reclamation_depot_level_automation_progress,
		"workshop_level_automation_progress": data.workshop_level_automation_progress,
		"game_time": data.game_time,
		"total_ticks": data.total_ticks
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
	data.materials = _load_big_number(save_data.get("materials", save_data.get("gold", 0.0)), BigNumber.zero())
	if save_data.has("scrap_yard"):
		data.scrap_yard.load_save_data(save_data.get("scrap_yard", {}))
	else:
		data.scrap_yard.level = max(1, int(save_data.get("scrap_yard_level", 1)))
		data.scrap_yard.count = max(1, int(save_data.get("scrap_yard_count", 1)))
	data.population = max(1.0, float(save_data.get("population", GameData.STARTING_POPULATION)))
	data.industrial_allocation_percent = clamp(float(save_data.get("industrial_allocation_percent", GameData.DEFAULT_INDUSTRIAL_ALLOCATION)), 0.0, 100.0)
	data.civilian_allocation_percent = clamp(float(save_data.get("civilian_allocation_percent", GameData.DEFAULT_CIVILIAN_ALLOCATION)), 0.0, 100.0)
	data.security_allocation_percent = clamp(float(save_data.get("security_allocation_percent", GameData.DEFAULT_SECURITY_ALLOCATION)), 0.0, 100.0)
	data.scientific_allocation_percent = clamp(float(save_data.get("scientific_allocation_percent", GameData.DEFAULT_SCIENTIFIC_ALLOCATION)), 0.0, 100.0)
	data.energy = max(0.0, float(save_data.get("energy", GameData.STARTING_ENERGY)))
	data.energy_priority = str(save_data.get("energy_priority", "Industrial"))
	data.reclamation_depot.load_save_data(save_data.get("reclamation_depot", {}))
	data.workshop.load_save_data(save_data.get("workshop", {}))
	data.factory.load_save_data(save_data.get("factory", {}))
	data.total_materials_produced = _load_big_number(save_data.get("total_materials_produced", null), data.materials)
	data.scrap_yard_level_automation_progress = max(0.0, float(save_data.get("scrap_yard_level_automation_progress", 0.0)))
	data.reclamation_depot_level_automation_progress = max(0.0, float(save_data.get("reclamation_depot_level_automation_progress", 0.0)))
	data.workshop_level_automation_progress = max(0.0, float(save_data.get("workshop_level_automation_progress", 0.0)))
	data.game_time = float(save_data.get("game_time", 0.0))
	data.total_ticks = int(save_data.get("total_ticks", 0))
	return true
