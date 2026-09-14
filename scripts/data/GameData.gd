class_name GameData
extends Resource

const STARTING_POPULATION: float = 100.0
const POPULATION_GROWTH_PER_SECOND: float = 1.0
const WORKFORCE_RATE: float = 0.5
const DEFAULT_INDUSTRIAL_ALLOCATION: float = 50.0
const DEFAULT_CIVILIAN_ALLOCATION: float = 30.0
const DEFAULT_SECURITY_ALLOCATION: float = 10.0
const DEFAULT_SCIENTIFIC_ALLOCATION: float = 10.0
const EFFICIENT_RANGE_HALF_WIDTH: float = 10.0

const LEVEL_UP_BASE_COST: float = 10.0
const LEVEL_UP_COST_GROWTH: float = 1.2
const SCRAP_YARD_BUILD_COST: float = 1_000_000_000_000.0
const SCRAP_YARD_BUILD_ENERGY_COST: float = 0.0
const SCRAP_YARD_LEVEL_UP_ENERGY_COST: float = 1.0

const RECLAMATION_DEPOT_UNLOCK_COST: float = 250.0
const RECLAMATION_DEPOT_LEVEL_UP_COST: float = 50.0
const RECLAMATION_DEPOT_BUILD_COST: float = 300.0
const RECLAMATION_DEPOT_BUILD_ENERGY_COST: float = 5.0
const WORKSHOP_UNLOCK_COST: float = 1_500.0
const WORKSHOP_LEVEL_UP_COST: float = 300.0
const WORKSHOP_BUILD_COST: float = 1_800.0
const WORKSHOP_BUILD_ENERGY_COST: float = 10.0
const FACTORY_UNLOCK_COST: float = 10_000.0
const FACTORY_LEVEL_UP_COST: float = 2_000.0
const FACTORY_BUILD_COST: float = 12_000.0
const FACTORY_BUILD_ENERGY_COST: float = 20.0

const RECLAMATION_SCRAP_YARD_LEVELS_PER_SECOND: float = 0.10
const WORKSHOP_RECLAMATION_DEPOT_LEVELS_PER_SECOND: float = 0.05
const FACTORY_WORKSHOP_LEVELS_PER_SECOND: float = 0.025
const AUTOMATION_COMPLETION_EPSILON: float = 0.000001

const STARTING_ENERGY: float = 20.0
const BASE_ENERGY_PRODUCTION_PER_SECOND: float = 10.0
const INDUSTRIAL_ENERGY_PRODUCTION_PER_WORKER: float = 0.05
const BASE_CIVILIAN_ENERGY_CONSUMPTION_PER_SECOND: float = 2.0
const SCRAP_YARD_ENERGY_PER_EFFECTIVE_OPERATION: float = 0.10
const RECLAMATION_DEPOT_ENERGY_PER_EFFECTIVE_OPERATION: float = 0.25
const WORKSHOP_ENERGY_PER_EFFECTIVE_OPERATION: float = 0.50
const FACTORY_ENERGY_PER_EFFECTIVE_OPERATION: float = 1.00

var materials: BigNumber
var total_materials_produced: BigNumber

@export var scrap_yard: ProductionOperation
@export var population: float = STARTING_POPULATION
@export var industrial_allocation_percent: float = DEFAULT_INDUSTRIAL_ALLOCATION
@export var civilian_allocation_percent: float = DEFAULT_CIVILIAN_ALLOCATION
@export var security_allocation_percent: float = DEFAULT_SECURITY_ALLOCATION
@export var scientific_allocation_percent: float = DEFAULT_SCIENTIFIC_ALLOCATION
@export var energy: float = STARTING_ENERGY
@export var energy_priority: String = "Industrial"
@export var reclamation_depot: ProductionOperation
@export var workshop: ProductionOperation
@export var factory: ProductionOperation
@export var scrap_yard_level_automation_progress: float = 0.0
@export var reclamation_depot_level_automation_progress: float = 0.0
@export var workshop_level_automation_progress: float = 0.0
@export var game_time: float = 0.0
@export var total_ticks: int = 0

func _init() -> void:
	materials = BigNumber.zero()
	total_materials_produced = BigNumber.zero()
	scrap_yard = ProductionOperation.new("Scrap Yard", 0.0, LEVEL_UP_BASE_COST, SCRAP_YARD_BUILD_COST, SCRAP_YARD_BUILD_ENERGY_COST, 1.0)
	scrap_yard.level_up_energy_cost = SCRAP_YARD_LEVEL_UP_ENERGY_COST
	scrap_yard.unlocked = true
	scrap_yard.count = 1
	reclamation_depot = ProductionOperation.new("Reclamation Depot", RECLAMATION_DEPOT_UNLOCK_COST, RECLAMATION_DEPOT_LEVEL_UP_COST, RECLAMATION_DEPOT_BUILD_COST, RECLAMATION_DEPOT_BUILD_ENERGY_COST)
	workshop = ProductionOperation.new("Workshop", WORKSHOP_UNLOCK_COST, WORKSHOP_LEVEL_UP_COST, WORKSHOP_BUILD_COST, WORKSHOP_BUILD_ENERGY_COST)
	factory = ProductionOperation.new("Factory", FACTORY_UNLOCK_COST, FACTORY_LEVEL_UP_COST, FACTORY_BUILD_COST, FACTORY_BUILD_ENERGY_COST)

func scrap_yard_production_per_second() -> BigNumber:
	var production: BigNumber = scrap_yard.total_effectiveness()
	production = production.multiply_float(industrial_productivity_multiplier())
	production = production.multiply_float(energy_production_multiplier())
	production = production.multiply_float(reclamation_depot_multiplier())
	return production

func reclamation_depot_multiplier() -> float:
	return 1.0 + reclamation_depot.total_effectiveness().to_float() * 0.10 * workshop_multiplier()

func workshop_multiplier() -> float:
	return 1.0 + workshop.total_effectiveness().to_float() * 0.10 * factory_multiplier()

func factory_multiplier() -> float:
	return 1.0 + factory.total_effectiveness().to_float() * 0.10

func reclamation_depot_scrap_yard_level_rate() -> float:
	return reclamation_depot.total_effectiveness().to_float() * RECLAMATION_SCRAP_YARD_LEVELS_PER_SECOND * energy_production_multiplier()

func workshop_reclamation_depot_level_rate() -> float:
	return workshop.total_effectiveness().to_float() * WORKSHOP_RECLAMATION_DEPOT_LEVELS_PER_SECOND * energy_production_multiplier()

func factory_workshop_level_rate() -> float:
	return factory.total_effectiveness().to_float() * FACTORY_WORKSHOP_LEVELS_PER_SECOND * energy_production_multiplier()

func process_chain_automation(delta: float) -> void:
	workshop_level_automation_progress += factory_workshop_level_rate() * delta
	var workshop_levels_gained: int = int(floor(workshop_level_automation_progress + AUTOMATION_COMPLETION_EPSILON))
	if workshop_levels_gained > 0:
		workshop.level += workshop_levels_gained
		workshop_level_automation_progress = max(0.0, workshop_level_automation_progress - float(workshop_levels_gained))

	reclamation_depot_level_automation_progress += workshop_reclamation_depot_level_rate() * delta
	var reclamation_depot_levels_gained: int = int(floor(reclamation_depot_level_automation_progress + AUTOMATION_COMPLETION_EPSILON))
	if reclamation_depot_levels_gained > 0:
		reclamation_depot.level += reclamation_depot_levels_gained
		reclamation_depot_level_automation_progress = max(0.0, reclamation_depot_level_automation_progress - float(reclamation_depot_levels_gained))

	scrap_yard_level_automation_progress += reclamation_depot_scrap_yard_level_rate() * delta
	var scrap_yard_levels_gained: int = int(floor(scrap_yard_level_automation_progress + AUTOMATION_COMPLETION_EPSILON))
	if scrap_yard_levels_gained > 0:
		scrap_yard.level += scrap_yard_levels_gained
		scrap_yard_level_automation_progress = max(0.0, scrap_yard_level_automation_progress - float(scrap_yard_levels_gained))

func can_unlock_reclamation_depot() -> bool:
	return not reclamation_depot.unlocked and materials.is_greater_or_equal(reclamation_depot.unlock_cost())

func can_unlock_workshop() -> bool:
	return not workshop.unlocked and reclamation_depot.unlocked and reclamation_depot.milestones_triggered >= 1 and materials.is_greater_or_equal(workshop.unlock_cost())

func can_unlock_factory() -> bool:
	return not factory.unlocked and workshop.unlocked and workshop.milestones_triggered >= 1 and materials.is_greater_or_equal(factory.unlock_cost())

func unlock_operation(operation: ProductionOperation) -> bool:
	var can_unlock: bool = false
	if operation == reclamation_depot:
		can_unlock = can_unlock_reclamation_depot()
	elif operation == workshop:
		can_unlock = can_unlock_workshop()
	elif operation == factory:
		can_unlock = can_unlock_factory()
	if not can_unlock:
		return false
	materials = operation.unlock(materials)
	return true

func level_up_operation(operation: ProductionOperation) -> bool:
	if not operation.unlocked:
		return false
	var level_up_cost: BigNumber = operation.level_up_cost()
	if materials.is_less_than(level_up_cost) or energy < operation.level_up_energy_cost:
		return false
	materials = operation.level_up(materials)
	energy -= operation.level_up_energy_cost
	return true

func build_new_operation(operation: ProductionOperation) -> bool:
	if not operation.unlocked:
		return false
	var result: Dictionary = operation.build_new(materials, energy)
	if not bool(result.get("success", false)):
		return false
	materials = result["materials"]
	energy = float(result["energy"])
	return true

func trigger_operation_milestone(operation: ProductionOperation) -> bool:
	if not operation.unlocked:
		return false
	var result: Dictionary = operation.trigger_milestone(energy)
	if not bool(result.get("success", false)):
		return false
	energy = float(result["energy"])
	return true

func scrap_yard_level_up_cost() -> BigNumber:
	return scrap_yard.level_up_cost()

func scrap_yard_build_new_cost() -> BigNumber:
	return scrap_yard.build_new_cost()

func can_level_up_scrap_yard() -> bool:
	return materials.is_greater_or_equal(scrap_yard.level_up_cost()) and energy >= scrap_yard.level_up_energy_cost

func level_up_scrap_yard() -> bool:
	return level_up_operation(scrap_yard)

func can_build_new_scrap_yard() -> bool:
	return scrap_yard.can_build_new(materials, energy)

func build_new_scrap_yard() -> bool:
	return build_new_operation(scrap_yard)

func can_trigger_scrap_yard_milestone() -> bool:
	return scrap_yard.can_trigger_milestone(energy)

func trigger_scrap_yard_milestone() -> bool:
	return trigger_operation_milestone(scrap_yard)

func scrap_yard_milestone_multiplier() -> BigNumber:
	return scrap_yard.milestone_multiplier()

func scrap_yard_next_milestone_level() -> int:
	return scrap_yard.next_milestone_level()

func scrap_yard_next_milestone_energy_cost() -> float:
	return scrap_yard.next_milestone_energy_cost()

func scrap_yard_manual_production() -> BigNumber:
	return scrap_yard_production_per_second()

func workforce_available() -> float:
	return population * WORKFORCE_RATE * industrial_allocation_efficiency()

func industrial_workforce_count() -> float:
	return workforce_available() * industrial_allocation_percent / 100.0

func industrial_productivity_multiplier() -> float:
	var starting_industrial_workforce: float = STARTING_POPULATION * WORKFORCE_RATE * DEFAULT_INDUSTRIAL_ALLOCATION / 100.0
	return industrial_workforce_count() / starting_industrial_workforce

func industrial_efficient_center_percent() -> float:
	return clamp(50.0 + (population - STARTING_POPULATION) / 50.0, 50.0, 70.0)

func industrial_efficient_min_percent() -> float:
	return industrial_efficient_center_percent() - EFFICIENT_RANGE_HALF_WIDTH

func industrial_efficient_max_percent() -> float:
	return industrial_efficient_center_percent() + EFFICIENT_RANGE_HALF_WIDTH

func industrial_allocation_efficiency() -> float:
	var distance_from_efficient_range: float = max(0.0, abs(industrial_allocation_percent - industrial_efficient_center_percent()) - EFFICIENT_RANGE_HALF_WIDTH)
	return clamp(1.0 - distance_from_efficient_range * 0.02, 0.4, 1.0)

func industrial_allocation_feedback_state() -> String:
	var distance_from_center: float = abs(industrial_allocation_percent - industrial_efficient_center_percent())
	if distance_from_center <= EFFICIENT_RANGE_HALF_WIDTH:
		return "GREEN"
	if distance_from_center <= 25.0:
		return "ORANGE"
	return "RED"

func set_industrial_allocation_percent(value: float) -> void:
	industrial_allocation_percent = clamp(value, 0.0, 100.0)
	_normalize_department_allocations()

func set_department_allocation(department: String, value: float) -> void:
	var old_value: float = get_department_allocation(department)
	var new_value: float = clamp(value, 0.0, 100.0)
	var delta: float = new_value - old_value
	set_department_raw(department, new_value)
	if delta > 0.0:
		var others: Array[String] = ["Industrial", "Civilian", "Security", "Scientific"]
		others.erase(department)
		var total_other: float = 0.0
		for name: String in others:
			total_other += get_department_allocation(name)
		if total_other > 0.0:
			for name: String in others:
				var current: float = get_department_allocation(name)
				set_department_raw(name, max(0.0, current - delta * current / total_other))
	_normalize_department_allocations()

func get_department_allocation(department: String) -> float:
	match department:
		"Industrial": return industrial_allocation_percent
		"Civilian": return civilian_allocation_percent
		"Security": return security_allocation_percent
		"Scientific": return scientific_allocation_percent
	return 0.0

func set_department_raw(department: String, value: float) -> void:
	match department:
		"Industrial": industrial_allocation_percent = value
		"Civilian": civilian_allocation_percent = value
		"Security": security_allocation_percent = value
		"Scientific": scientific_allocation_percent = value

func _normalize_department_allocations() -> void:
	var total: float = industrial_allocation_percent + civilian_allocation_percent + security_allocation_percent + scientific_allocation_percent
	if total <= 0.0:
		industrial_allocation_percent = DEFAULT_INDUSTRIAL_ALLOCATION
		civilian_allocation_percent = DEFAULT_CIVILIAN_ALLOCATION
		security_allocation_percent = DEFAULT_SECURITY_ALLOCATION
		scientific_allocation_percent = DEFAULT_SCIENTIFIC_ALLOCATION
		return
	var scale: float = 100.0 / total
	industrial_allocation_percent *= scale
	civilian_allocation_percent *= scale
	security_allocation_percent *= scale
	scientific_allocation_percent *= scale

func grow_population(delta: float) -> void:
	population += POPULATION_GROWTH_PER_SECOND * delta

func energy_production_per_second() -> float:
	return BASE_ENERGY_PRODUCTION_PER_SECOND + industrial_workforce_count() * INDUSTRIAL_ENERGY_PRODUCTION_PER_WORKER

func energy_consumption_per_second() -> float:
	var scrap_effective: float = scrap_yard.total_effectiveness().to_float()
	var depot_effective: float = reclamation_depot.total_effectiveness().to_float()
	var workshop_effective: float = workshop.total_effectiveness().to_float()
	var factory_effective: float = factory.total_effectiveness().to_float()
	return BASE_CIVILIAN_ENERGY_CONSUMPTION_PER_SECOND \
		+ scrap_effective * SCRAP_YARD_ENERGY_PER_EFFECTIVE_OPERATION \
		+ depot_effective * RECLAMATION_DEPOT_ENERGY_PER_EFFECTIVE_OPERATION \
		+ workshop_effective * WORKSHOP_ENERGY_PER_EFFECTIVE_OPERATION \
		+ factory_effective * FACTORY_ENERGY_PER_EFFECTIVE_OPERATION

func energy_balance_per_second() -> float:
	return energy_production_per_second() - energy_consumption_per_second()

func energy_production_multiplier() -> float:
	var production: float = energy_production_per_second()
	var consumption: float = energy_consumption_per_second()
	if consumption <= 0.0 or production >= consumption:
		return 1.0
	var shortage_ratio: float = production / consumption
	match energy_priority:
		"Industrial": return clamp(shortage_ratio + 0.10, 0.0, 1.0)
		"Civilian": return clamp(shortage_ratio, 0.0, 1.0)
		"Security": return clamp(shortage_ratio + 0.05, 0.0, 1.0)
		"Scientific": return clamp(shortage_ratio + 0.05, 0.0, 1.0)
	return clamp(shortage_ratio, 0.0, 1.0)

func process_energy(delta: float) -> void:
	energy += energy_balance_per_second() * delta
	energy = max(0.0, energy)

func energy_shortage_state() -> String:
	var production: float = energy_production_per_second()
	var consumption: float = energy_consumption_per_second()
	if consumption <= production:
		return "STABLE"
	var ratio: float = production / consumption
	if ratio >= 0.75:
		return "STRAINED"
	if ratio >= 0.50:
		return "SHORTAGE"
	return "CRITICAL"

func set_energy_priority(priority: String) -> void:
	if ["Industrial", "Civilian", "Security", "Scientific"].has(priority):
		energy_priority = priority

func produce_materials(amount: BigNumber) -> void:
	materials = materials.add(amount)
	total_materials_produced = total_materials_produced.add(amount)
