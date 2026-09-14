class_name GameData
extends Resource

const LEVEL_UP_BASE_COST: float = 10.0
const LEVEL_UP_COST_GROWTH: float = 1.2

const SCRAP_YARD_BUILD_COST: float = 10.0
const SCRAP_YARD_BUILD_ENERGY_COST: float = 1.0
const SCRAP_YARD_LEVEL_UP_ENERGY_COST: float = 1.0
const SCRAP_YARD_MATERIAL_PER_EFFECTIVE_UNIT: float = 1.0

const RECLAMATION_DEPOT_UNLOCK_COST: float = 250.0
const RECLAMATION_DEPOT_LEVEL_UP_COST: float = 100.0
const RECLAMATION_DEPOT_LEVEL_UP_ENERGY_COST: float = 10.0
const RECLAMATION_DEPOT_BUILD_COST: float = 300.0
const RECLAMATION_DEPOT_BUILD_ENERGY_COST: float = 5.0
const RECLAMATION_DEPOT_SCRAP_YARDS_PER_SECOND: float = 0.10

const WORKSHOP_UNLOCK_COST: float = 1_500.0
const WORKSHOP_LEVEL_UP_COST: float = 300.0
const WORKSHOP_LEVEL_UP_ENERGY_COST: float = 10.0
const WORKSHOP_BUILD_COST: float = 1_800.0
const WORKSHOP_BUILD_ENERGY_COST: float = 10.0
const WORKSHOP_RECLAMATION_DEPOTS_PER_SECOND: float = 0.05

const FACTORY_UNLOCK_COST: float = 10_000.0
const FACTORY_LEVEL_UP_COST: float = 2_000.0
const FACTORY_LEVEL_UP_ENERGY_COST: float = 20.0
const FACTORY_BUILD_COST: float = 12_000.0
const FACTORY_BUILD_ENERGY_COST: float = 20.0
const FACTORY_WORKSHOPS_PER_SECOND: float = 0.025

const STARTING_ENERGY: float = 20.0
const BASE_ENERGY_PRODUCTION_PER_SECOND: float = 1.0

var materials: BigNumber
var total_materials_produced: BigNumber

@export var scrap_yard: ProductionOperation
@export var reclamation_depot: ProductionOperation
@export var workshop: ProductionOperation
@export var factory: ProductionOperation
@export var energy: float = STARTING_ENERGY
@export var game_time: float = 0.0
@export var total_ticks: int = 0

var scrap_yard_production_progress: float = 0.0
var reclamation_depot_production_progress: float = 0.0
var workshop_production_progress: float = 0.0

func _init() -> void:
	materials = BigNumber.zero()
	total_materials_produced = BigNumber.zero()

	scrap_yard = ProductionOperation.new("Scrap Yard", 0.0, LEVEL_UP_BASE_COST, SCRAP_YARD_BUILD_COST, SCRAP_YARD_BUILD_ENERGY_COST, 15.0, LEVEL_UP_COST_GROWTH)
	scrap_yard.level_up_energy_cost = SCRAP_YARD_LEVEL_UP_ENERGY_COST
	scrap_yard.unlocked = true
	scrap_yard.count = 1

	reclamation_depot = ProductionOperation.new("Reclamation Depot", RECLAMATION_DEPOT_UNLOCK_COST, RECLAMATION_DEPOT_LEVEL_UP_COST, RECLAMATION_DEPOT_BUILD_COST, RECLAMATION_DEPOT_BUILD_ENERGY_COST)
	reclamation_depot.level_up_energy_cost = RECLAMATION_DEPOT_LEVEL_UP_ENERGY_COST

	workshop = ProductionOperation.new("Workshop", WORKSHOP_UNLOCK_COST, WORKSHOP_LEVEL_UP_COST, WORKSHOP_BUILD_COST, WORKSHOP_BUILD_ENERGY_COST)
	workshop.level_up_energy_cost = WORKSHOP_LEVEL_UP_ENERGY_COST

	factory = ProductionOperation.new("Factory", FACTORY_UNLOCK_COST, FACTORY_LEVEL_UP_COST, FACTORY_BUILD_COST, FACTORY_BUILD_ENERGY_COST)
	factory.level_up_energy_cost = FACTORY_LEVEL_UP_ENERGY_COST

func scrap_yard_production_per_second() -> BigNumber:
	return scrap_yard.total_effectiveness().multiply_float(SCRAP_YARD_MATERIAL_PER_EFFECTIVE_UNIT)

func reclamation_depot_scrap_yard_rate() -> float:
	return reclamation_depot.total_effectiveness().to_float() * RECLAMATION_DEPOT_SCRAP_YARDS_PER_SECOND

func workshop_reclamation_depot_rate() -> float:
	return workshop.total_effectiveness().to_float() * WORKSHOP_RECLAMATION_DEPOTS_PER_SECOND

func factory_workshop_rate() -> float:
	return factory.total_effectiveness().to_float() * FACTORY_WORKSHOPS_PER_SECOND

func can_unlock_reclamation_depot() -> bool:
	return not reclamation_depot.unlocked and materials.is_greater_or_equal(reclamation_depot.unlock_cost())

func can_unlock_workshop() -> bool:
	return not workshop.unlocked and reclamation_depot.unlocked and reclamation_depot.milestones_triggered >= 1 and materials.is_greater_or_equal(workshop.unlock_cost())

func can_unlock_factory() -> bool:
	return not factory.unlocked and workshop.unlocked and workshop.milestones_triggered >= 1 and materials.is_greater_or_equal(factory.unlock_cost())

func unlock_operation(operation: ProductionOperation) -> bool:
	if operation == reclamation_depot and not can_unlock_reclamation_depot():
		return false
	if operation == workshop and not can_unlock_workshop():
		return false
	if operation == factory and not can_unlock_factory():
		return false
	if operation == scrap_yard or operation.unlocked:
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

func can_level_up_reclamation_depot() -> bool:
	return reclamation_depot.unlocked and materials.is_greater_or_equal(reclamation_depot.level_up_cost()) and energy >= reclamation_depot.level_up_energy_cost

func level_up_reclamation_depot() -> bool:
	return level_up_operation(reclamation_depot)

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
	energy = float(result.get("energy", energy))
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

func process_production(delta: float) -> void:
	produce_materials(scrap_yard_production_per_second().multiply_float(delta))

	if reclamation_depot.unlocked:
		reclamation_depot_production_progress += reclamation_depot_scrap_yard_rate() * delta
		var scrap_yards_to_add: int = int(floor(reclamation_depot_production_progress))
		if scrap_yards_to_add > 0:
			scrap_yard.count += scrap_yards_to_add
			reclamation_depot_production_progress -= float(scrap_yards_to_add)

	if workshop.unlocked:
		workshop_production_progress += workshop_reclamation_depot_rate() * delta
		var depots_to_add: int = int(floor(workshop_production_progress))
		if depots_to_add > 0:
			reclamation_depot.count += depots_to_add
			workshop_production_progress -= float(depots_to_add)

	if factory.unlocked:
		factory_production_progress += factory_workshop_rate() * delta
		var workshops_to_add: int = int(floor(factory_production_progress))
		if workshops_to_add > 0:
			workshop.count += workshops_to_add
			factory_production_progress -= float(workshops_to_add)

func produce_materials(amount: BigNumber) -> void:
	materials = materials.add(amount)
	total_materials_produced = total_materials_produced.add(amount)

func energy_production_per_second() -> float:
	return BASE_ENERGY_PRODUCTION_PER_SECOND

func energy_consumption_per_second() -> float:
	return 0.0

func energy_balance_per_second() -> float:
	return energy_production_per_second()

func process_energy(delta: float) -> void:
	energy += energy_balance_per_second() * delta

func process(delta: float) -> void:
	game_time += delta
	total_ticks += 1
	process_energy(delta)
	process_production(delta)
