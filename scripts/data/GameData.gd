class_name GameData
extends Resource

const SCRAP_YARD_MILESTONE_INTERVAL := 10
const LEVEL_UP_BASE_COST := 10.0
const LEVEL_UP_COST_GROWTH := 1.15
const BUILD_NEW_BASE_COST := 100.0
const BUILD_NEW_COST_GROWTH := 1.6
const STARTING_POPULATION := 100.0
const POPULATION_GROWTH_PER_SECOND := 1.0
const WORKFORCE_RATE := 0.5
const DEFAULT_INDUSTRIAL_ALLOCATION := 50.0
const EFFICIENT_RANGE_HALF_WIDTH := 10.0

@export var materials: float = 0.0
@export var scrap_yard_level: int = 1
@export var scrap_yard_count: int = 1
@export var population: float = STARTING_POPULATION
@export var industrial_allocation_percent: float = DEFAULT_INDUSTRIAL_ALLOCATION
@export var game_time: float = 0.0
@export var total_ticks: int = 0


func scrap_yard_production_per_second() -> float:
	return scrap_yard_level_production_per_second() * scrap_yard_count * scrap_yard_milestone_multiplier() * industrial_productivity_multiplier()


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


func workforce_available() -> float:
	return population * WORKFORCE_RATE * industrial_allocation_efficiency()


func industrial_workforce_count() -> float:
	return workforce_available() * industrial_allocation_percent / 100.0


func industrial_productivity_multiplier() -> float:
	var starting_industrial_workforce := STARTING_POPULATION * WORKFORCE_RATE * DEFAULT_INDUSTRIAL_ALLOCATION / 100.0
	return industrial_workforce_count() / starting_industrial_workforce


func industrial_efficient_center_percent() -> float:
	# Larger settlements can efficiently support a larger industrial share.
	return clamp(50.0 + (population - STARTING_POPULATION) / 50.0, 50.0, 70.0)


func industrial_efficient_min_percent() -> float:
	return industrial_efficient_center_percent() - EFFICIENT_RANGE_HALF_WIDTH


func industrial_efficient_max_percent() -> float:
	return industrial_efficient_center_percent() + EFFICIENT_RANGE_HALF_WIDTH


func industrial_allocation_efficiency() -> float:
	var distance_from_efficient_range : float = max(0.0, abs(industrial_allocation_percent - industrial_efficient_center_percent()) - EFFICIENT_RANGE_HALF_WIDTH)
	return clamp(1.0 - distance_from_efficient_range * 0.02, 0.4, 1.0)


func industrial_allocation_feedback_state() -> String:
	var distance_from_center : float = abs(industrial_allocation_percent - industrial_efficient_center_percent())
	if distance_from_center <= EFFICIENT_RANGE_HALF_WIDTH:
		return "GREEN"
	if distance_from_center <= 25.0:
		return "ORANGE"
	return "RED"


func set_industrial_allocation_percent(value: float) -> void:
	industrial_allocation_percent = clamp(value, 0.0, 100.0)


func grow_population(delta: float) -> void:
	population += POPULATION_GROWTH_PER_SECOND * delta


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
