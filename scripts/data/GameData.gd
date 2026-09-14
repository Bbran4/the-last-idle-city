class_name GameData
extends Resource

const LEVEL_UP_BASE_COST := 10.0     # was 25.0 — first level-up costs exactly 1 Material
const LEVEL_UP_COST_GROWTH := 1.2   # was 1.28
const BUILD_NEW_BASE_COST := 1_000_000_000_000.0   # 1e12 = 1 trillion (cost to build the 2nd yard)
const BUILD_NEW_COST_GROWTH := 1_000_000_000_000_000_000_000.0  # 1e21
const STARTING_POPULATION := 100.0
const POPULATION_GROWTH_PER_SECOND := 1.0
const WORKFORCE_RATE := 0.5
const DEFAULT_INDUSTRIAL_ALLOCATION := 50.0
const EFFICIENT_RANGE_HALF_WIDTH := 10.0
const RECLAMATION_DEPOT_UNLOCK_COST := 250.0
const WORKSHOP_UNLOCK_COST := 1_500.0
const FACTORY_UNLOCK_COST := 10_000.0
const RECLAMATION_SCRAP_YARD_LEVELS_PER_SECOND := 0.10
const WORKSHOP_RECLAMATION_DEPOT_LEVELS_PER_SECOND := 0.05
const FACTORY_WORKSHOP_LEVELS_PER_SECOND := 0.025
const AUTOMATION_COMPLETION_EPSILON := 0.000001

# NOTE: materials / total_materials_produced are BigNumber (RefCounted),
# not a Resource-derived type, so they are intentionally NOT @export'd —
# Godot's inspector export only supports Resource/Node/variant types.
# SaveManager handles their persistence manually instead.
var materials: BigNumber
var total_materials_produced: BigNumber

@export var scrap_yard_level: int = 1
@export var scrap_yard_count: int = 1
@export var population: float = STARTING_POPULATION
@export var industrial_allocation_percent: float = DEFAULT_INDUSTRIAL_ALLOCATION
@export var reclamation_depot: ProductionOperation
@export var workshop: ProductionOperation
@export var factory: ProductionOperation
@export var scrap_yard_level_automation_progress := 0.0
@export var reclamation_depot_level_automation_progress := 0.0
@export var workshop_level_automation_progress := 0.0
@export var game_time: float = 0.0
@export var total_ticks: int = 0


func _init() -> void:
	materials = BigNumber.zero()
	total_materials_produced = BigNumber.zero()
	reclamation_depot = ProductionOperation.new("Reclamation Depot", RECLAMATION_DEPOT_UNLOCK_COST, 50.0, 300.0)
	workshop = ProductionOperation.new("Workshop", WORKSHOP_UNLOCK_COST, 300.0, 1_800.0)
	factory = ProductionOperation.new("Factory", FACTORY_UNLOCK_COST, 2_000.0, 12_000.0)


func scrap_yard_production_per_second() -> BigNumber:
	var production := BigNumber.from_float(scrap_yard_level_production_per_second())
	production = production.multiply_float(float(scrap_yard_count))
	production = production.multiply(scrap_yard_milestone_multiplier())
	production = production.multiply_float(industrial_productivity_multiplier())
	production = production.multiply_float(reclamation_depot_multiplier())
	return production


func reclamation_depot_multiplier() -> float:
	# Reclamation directly accelerates Scrap Yard output. Workshop boosts this link.
	# NOTE: this stays float-based for now — total_effectiveness() is BigNumber,
	# but converting it back with to_float() means this specific multiplier chain
	# will eventually saturate to INF at extreme effectiveness values, same as
	# the old milestone_multiplier did. Flagging as a known follow-up rather than
	# fully propagating BigNumber through the recursive chain/workshop/factory
	# multipliers right now.
	return 1.0 + reclamation_depot.total_effectiveness().to_float() * 0.10 * workshop_multiplier()


func workshop_multiplier() -> float:
	# Workshop accelerates the Reclamation Depot. Factory boosts this link.
	return 1.0 + workshop.total_effectiveness().to_float() * 0.10 * factory_multiplier()


func factory_multiplier() -> float:
	# Factory is the top of this first automated production chain.
	return 1.0 + factory.total_effectiveness().to_float() * 0.10


func reclamation_depot_scrap_yard_level_rate() -> float:
	return reclamation_depot.total_effectiveness().to_float() * RECLAMATION_SCRAP_YARD_LEVELS_PER_SECOND


func workshop_reclamation_depot_level_rate() -> float:
	return workshop.total_effectiveness().to_float() * WORKSHOP_RECLAMATION_DEPOT_LEVELS_PER_SECOND


func factory_workshop_level_rate() -> float:
	return factory.total_effectiveness().to_float() * FACTORY_WORKSHOP_LEVELS_PER_SECOND


func process_chain_automation(delta: float) -> void:
	# Each higher-tier operation levels the next operation down the chain at its stated rate.
	workshop_level_automation_progress += factory_workshop_level_rate() * delta
	var workshop_levels_gained := int(floor(workshop_level_automation_progress + AUTOMATION_COMPLETION_EPSILON))
	if workshop_levels_gained > 0:
		workshop.level += workshop_levels_gained
		workshop_level_automation_progress = max(0.0, workshop_level_automation_progress - workshop_levels_gained)

	reclamation_depot_level_automation_progress += workshop_reclamation_depot_level_rate() * delta
	var reclamation_depot_levels_gained := int(floor(reclamation_depot_level_automation_progress + AUTOMATION_COMPLETION_EPSILON))
	if reclamation_depot_levels_gained > 0:
		reclamation_depot.level += reclamation_depot_levels_gained
		reclamation_depot_level_automation_progress = max(0.0, reclamation_depot_level_automation_progress - reclamation_depot_levels_gained)

	scrap_yard_level_automation_progress += reclamation_depot_scrap_yard_level_rate() * delta
	var scrap_yard_levels_gained := int(floor(scrap_yard_level_automation_progress + AUTOMATION_COMPLETION_EPSILON))
	if scrap_yard_levels_gained > 0:
		scrap_yard_level += scrap_yard_levels_gained
		scrap_yard_level_automation_progress = max(0.0, scrap_yard_level_automation_progress - scrap_yard_levels_gained)


func can_unlock_reclamation_depot() -> bool:
	return not reclamation_depot.unlocked and materials.is_greater_or_equal(reclamation_depot.unlock_cost())


func can_unlock_workshop() -> bool:
	return not workshop.unlocked and reclamation_depot.unlocked and reclamation_depot.level >= ProductionOperation.FIRST_MILESTONE_LEVEL and materials.is_greater_or_equal(workshop.unlock_cost())


func can_unlock_factory() -> bool:
	return not factory.unlocked and workshop.unlocked and workshop.level >= ProductionOperation.FIRST_MILESTONE_LEVEL and materials.is_greater_or_equal(factory.unlock_cost())

func unlock_operation(operation: ProductionOperation) -> bool:
	var can_unlock := false
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
	if not operation.unlocked or materials.is_less_than(operation.level_up_cost()):
		return false

	materials = operation.level_up(materials)
	return true


func build_new_operation(operation: ProductionOperation) -> bool:
	if not operation.unlocked or materials.is_less_than(operation.build_new_cost()):
		return false

	materials = operation.build_new(materials)
	return true


func scrap_yard_level_production_per_second() -> float:
	return float(scrap_yard_level)


func scrap_yard_milestone_multiplier() -> BigNumber:
	# Uses the shared milestone table (ProductionOperation.MILESTONE_LEVELS)
	# so Scrap Yard and every other operation cross milestones at the same levels.
	return ProductionOperation.milestone_multiplier_for_level(scrap_yard_level)


func scrap_yard_next_milestone_level() -> int:
	return ProductionOperation.next_milestone_level(scrap_yard_level)

func scrap_yard_manual_production() -> BigNumber:
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


func scrap_yard_level_up_cost() -> BigNumber:
	return BigNumber.from_float(LEVEL_UP_BASE_COST).multiply(
		BigNumber.from_float(LEVEL_UP_COST_GROWTH).pow_int(scrap_yard_level - 1)
	)


func scrap_yard_build_new_cost() -> BigNumber:
	return BigNumber.from_float(BUILD_NEW_BASE_COST).multiply(
		BigNumber.from_float(BUILD_NEW_COST_GROWTH).pow_int(scrap_yard_count - 1)
	)


func can_level_up_scrap_yard() -> bool:
	return materials.is_greater_or_equal(scrap_yard_level_up_cost())


func level_up_scrap_yard() -> bool:
	if not can_level_up_scrap_yard():
		return false

	materials = materials.subtract(scrap_yard_level_up_cost())
	scrap_yard_level += 1

	return true


func can_build_new_scrap_yard() -> bool:
	return materials.is_greater_or_equal(scrap_yard_build_new_cost())


func build_new_scrap_yard() -> bool:
	if not can_build_new_scrap_yard():
		return false

	materials = materials.subtract(scrap_yard_build_new_cost())
	# BUILD NEW is the only action that adds a Scrap Yard building.
	scrap_yard_count += 1
	return true


func produce_materials(amount: BigNumber) -> void:
	materials = materials.add(amount)
	total_materials_produced = total_materials_produced.add(amount)
