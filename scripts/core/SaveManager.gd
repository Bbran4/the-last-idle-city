class_name SaveManager
extends RefCounted

const SAVE_PATH := "user://savegame.json"

static func save_game() -> bool:
	var save_data := {
		"materials": GameState.data.materials.to_dict(),
		"scrap_yard_level": GameState.data.scrap_yard_level,
		"scrap_yard_count": GameState.data.scrap_yard_count,
		"population": GameState.data.population,
		"industrial_allocation_percent": GameState.data.industrial_allocation_percent,
		"civilian_allocation_percent": GameState.data.civilian_allocation_percent,
		"security_allocation_percent": GameState.data.security_allocation_percent,
		"scientific_allocation_percent": GameState.data.scientific_allocation_percent,
		"energy": GameState.data.energy,
		"energy_priority": GameState.data.energy_priority,
		"reclamation_depot": GameState.data.reclamation_depot.save_data(),
		"workshop": GameState.data.workshop.save_data(),
		"factory": GameState.data.factory.save_data(),
		"production_unit_a": GameState.data.production_unit_a.save_data(),
		"production_unit_b": GameState.data.production_unit_b.save_data(),
		"production_unit_c": GameState.data.production_unit_c.save_data(),
		"total_materials_produced": GameState.data.total_materials_produced.to_dict(),
		"scrap_yard_level_automation_progress": GameState.data.scrap_yard_level_automation_progress,
		"reclamation_depot_level_automation_progress": GameState.data.reclamation_depot_level_automation_progress,
		"workshop_level_automation_progress": GameState.data.workshop_level_automation_progress,
		"production_unit_a_progress": GameState.data.production_unit_a_progress,
		"production_unit_b_progress": GameState.data.production_unit_b_progress,
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

static func _load_big_number(value: Variant, fallback: BigNumber) -> BigNumber:
	if value is Dictionary:
		return BigNumber.from_dict(value)
	if value is float or value is int:
		return BigNumber.from_float(float(value))
	return fallback

static func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_error("Unable to open save file.")
		return false
	var json := JSON.new()
	if json.parse(file.get_as_text()) != OK:
		file.close()
		push_error("Save file contains invalid JSON.")
		return false
	file.close()
	var save_data = json.data
	if not save_data is Dictionary:
		push_error("Save data is not a Dictionary.")
		return false
	GameState.data.materials = _load_big_number(save_data.get("materials", save_data.get("gold", 0.0)), BigNumber.zero())
	GameState.data.scrap_yard_level = max(1, int(save_data.get("scrap_yard_level", 1)))
	GameState.data.scrap_yard_count = max(1, int(save_data.get("scrap_yard_count", 1)))
	GameState.data.population = max(1.0, float(save_data.get("population", GameData.STARTING_POPULATION)))
	GameState.data.industrial_allocation_percent = clamp(float(save_data.get("industrial_allocation_percent", GameData.DEFAULT_INDUSTRIAL_ALLOCATION)), 0.0, 100.0)
	GameState.data.civilian_allocation_percent = clamp(float(save_data.get("civilian_allocation_percent", GameData.DEFAULT_CIVILIAN_ALLOCATION)), 0.0, 100.0)
	GameState.data.security_allocation_percent = clamp(float(save_data.get("security_allocation_percent", GameData.DEFAULT_SECURITY_ALLOCATION)), 0.0, 100.0)
	GameState.data.scientific_allocation_percent = clamp(float(save_data.get("scientific_allocation_percent", GameData.DEFAULT_SCIENTIFIC_ALLOCATION)), 0.0, 100.0)
	GameState.data.energy = max(0.0, float(save_data.get("energy", GameData.STARTING_ENERGY)))
	GameState.data.energy_priority = str(save_data.get("energy_priority", "Industrial"))
	GameState.data.reclamation_depot.load_save_data(save_data.get("reclamation_depot", {}))
	GameState.data.workshop.load_save_data(save_data.get("workshop", {}))
	GameState.data.factory.load_save_data(save_data.get("factory", {}))
	GameState.data.production_unit_a.load_save_data(save_data.get("production_unit_a", {}))
	GameState.data.production_unit_b.load_save_data(save_data.get("production_unit_b", {}))
	GameState.data.production_unit_c.load_save_data(save_data.get("production_unit_c", {}))
	GameState.data.total_materials_produced = _load_big_number(save_data.get("total_materials_produced", null), GameState.data.materials)
	GameState.data.scrap_yard_level_automation_progress = max(0.0, float(save_data.get("scrap_yard_level_automation_progress", 0.0)))
	GameState.data.reclamation_depot_level_automation_progress = max(0.0, float(save_data.get("reclamation_depot_level_automation_progress", 0.0)))
	GameState.data.workshop_level_automation_progress = max(0.0, float(save_data.get("workshop_level_automation_progress", 0.0)))
	GameState.data.production_unit_a_progress = max(0.0, float(save_data.get("production_unit_a_progress", 0.0)))
	GameState.data.production_unit_b_progress = max(0.0, float(save_data.get("production_unit_b_progress", 0.0)))
	GameState.data.game_time = float(save_data.get("game_time", 0.0))
	GameState.data.total_ticks = int(save_data.get("total_ticks", 0))
	return true
