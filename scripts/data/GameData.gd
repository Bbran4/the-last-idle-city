class_name GameData
extends Resource

const SCRAP_YARD_MILESTONE_INTERVAL := 10
const LEVEL_UP_BASE_COST := 10.0
const LEVEL_UP_COST_GROWTH := 1.15
const BUILD_NEW_BASE_COST := 100.0
const BUILD_NEW_COST_GROWTH := 1.6

@export var materials: float = 0.0
@export var scrap_yard_level: int = 1
@export var scrap_yard_count: int = 1
@export var game_time: float = 0.0
@export var total_ticks: int = 0


func scrap_yard_production_per_second() -> float:
	return scrap_yard_level_production_per_second() * scrap_yard_count * scrap_yard_milestone_multiplier()


func scrap_yard_level_production_per_second() -> float:
	return float(scrap_yard_level)


func scrap_yard_milestone_multiplier() -> float:
	var milestone_tier := int(scrap_yard_level / SCRAP_YARD_MILESTONE_INTERVAL)
	return pow(2.0, milestone_tier)


func scrap_yard_next_milestone_level() -> int:
	return (int(scrap_yard_level / SCRAP_YARD_MILESTONE_INTERVAL) + 1) * SCRAP_YARD_MILESTONE_INTERVAL


func scrap_yard_manual_production() -> float:
	# Manual processing benefits from the same upgrades as idle production.
	return scrap_yard_production_per_second()


func scrap_yard_level_up_cost() -> float:
	return LEVEL_UP_BASE_COST * pow(LEVEL_UP_COST_GROWTH, scrap_yard_level - 1)


func scrap_yard_build_new_cost() -> float:
	return BUILD_NEW_BASE_COST * pow(BUILD_NEW_COST_GROWTH, scrap_yard_count - 1)


func can_level_up_scrap_yard() -> bool:
	return materials >= scrap_yard_level_up_cost()


func level_up_scrap_yard() -> bool:
	if not can_level_up_scrap_yard():
		return false

	materials -= scrap_yard_level_up_cost()
	scrap_yard_level += 1

	# Every tenth shared level expands the operation automatically.
	if scrap_yard_level % SCRAP_YARD_MILESTONE_INTERVAL == 0:
		scrap_yard_count += 1

	return true


func can_build_new_scrap_yard() -> bool:
	return materials >= scrap_yard_build_new_cost()


func build_new_scrap_yard() -> bool:
	if not can_build_new_scrap_yard():
		return false

	materials -= scrap_yard_build_new_cost()
	scrap_yard_count += 1
	return true


func produce_materials(amount: float) -> void:
	materials += amount
