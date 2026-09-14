class_name GameData
extends Resource

const LEVEL_UP_BASE_COST := 10.0
const LEVEL_UP_COST_GROWTH := 1.2
const BUILD_NEW_BASE_COST := 1_000_000_000_000.0
const BUILD_NEW_COST_GROWTH := 1_000_000_000_000_000_000_000.0
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

const STARTING_ENERGY := 20.0
const BASE_ENERGY_PRODUCTION_PER_SECOND := 10.0
const BASE_CIVILIAN_ENERGY_CONSUMPTION_PER_SECOND := 2.0
const SCRAP_YARD_ENERGY_PER_EFFECTIVE_OPERATION := 0.10
const RECLAMATION_DEPOT_ENERGY_PER_EFFECTIVE_OPERATION := 0.25
const WORKSHOP_ENERGY_PER_EFFECTIVE_OPERATION := 0.50
const FACTORY_ENERGY_PER_EFFECTIVE_OPERATION := 1.00

const DEFAULT_CIVILIAN_ALLOCATION := 30.0
const DEFAULT_SECURITY_ALLOCATION := 10.0
const DEFAULT_SCIENTIFIC_ALLOCATION := 10.0

var materials: BigNumber
var total_materials_produced: BigNumber

@export var scrap_yard_level: int = 1
@export var scrap_yard_count: int = 1
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
@export var production_unit_a: ProductionUnit
@export var production_unit_b: ProductionUnit
@export var production_unit_c: ProductionUnit
@export var scrap_yard_level_automation_progress := 0.0
@export var reclamation_depot_level_automation_progress := 0.0
@export var workshop_level_automation_progress := 0.0
@export var production_unit_a_progress := 0.0
@export var production_unit_b_progress := 0.0
@export var game_time: float = 0.0
@export var total_ticks: int = 0


func _init() -> void:
	materials = BigNumber.zero()
	total_materials_produced = BigNumber.zero()
	reclamation_depot = ProductionOperation.new("Reclamation Depot", RECLAMATION_DEPOT_UNLOCK_COST, 50.0, 300.0)
	workshop = ProductionOperation.new("Workshop", WORKSHOP_UNLOCK_COST, 300.0, 1_800.0)
	factory = ProductionOperation.new("Factory", FACTORY_UNLOCK_COST, 2_000.0, 12_000.0)

	production_unit_a = ProductionUnit.new()
	production_unit_a.display_name = "Production Unit A"
	production_unit_a.purchase_base_cost = 10.0

	production_unit_b = ProductionUnit.new()
	production_unit_b.display_name = "Production Unit B"
	production_unit_b.purchase_base_cost = 100.0
	production_unit_b.requires_secondary_unit_count = 100

	production_unit_c = ProductionUnit.new()
	production_unit_c.display_name = "Production Unit C"
	production_unit_c.purchase_base_cost = 1_000.0
	production_unit_c.requires_secondary_unit_count = 100


func scrap_yard_production_per_second() -> BigNumber:
	var production := BigNumber.from_float(scrap_yard_level_production_per_second())
	production = production.multiply_float(float(scrap_yard_count))
	production = production.multiply(scrap_yard_milestone_multiplier())
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


func process_unit_automation(delta: float) -> void:
	production_unit_b_progress += production_unit_c.production_per_second().to_float() * delta
	var b_gained := int(floor(production_unit_b_progress))
	if b_gained > 0:
		production_unit_b.count += b_gained
		production_unit_b_progress -= b_gained

	production_unit_a_progress += production_unit_b.production_per_second().to_float() * delta
	var a_gained := int(floor(production_unit_a_progress))
	if a_gained > 0:
		production_unit_a.count += a_gained
		production_unit_a_progress -= a_gained


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
	return ProductionOperation.milestone_multiplier_for_level(scrap_yard_level)


func scrap_yard_next_milestone_level() -> int:
	return ProductionOperation.next_milestone_level(scrap_yard_level)


func scrap_yard_manual_production() -> BigNumber:
	return scrap_yard_production_per_second()


func workforce_available() -> float:
	return population * WORKFORCE_RATE * industrial_allocation_efficiency()


func industrial_workforce_count() -> float:
	return workforce_available() * industrial_allocation_percent / 100.0


func industrial_productivity_multiplier() -> float:
	var starting_industrial_workforce := STARTING_POPULATION * WORKFORCE_RATE * DEFAULT_INDUSTRIAL_ALLOCATION / 100.0
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
	var old_value : float = get_department_allocation(department)
	var new_value : float = clamp(value, 0.0, 100.0)
	var delta := new_value - old_value
	set_department_raw(department, new_value)
	if delta > 0.0:
		var others := ["Industrial", "Civilian", "Security", "Scientific"]
		others.erase(department)
		var total_other := 0.0
		for name in others:
			total_other += get_department_allocation(name)
		if total_other > 0.0:
			for name in others:
				set_department_raw(name, max(0.0, get_department_allocation(name) - delta * get_department_allocation(name) / total_other))
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
	var total := industrial_allocation_percent + civilian_allocation_percent + security_allocation_percent + scientific_allocation_percent
	if total <= 0.0:
		industrial_allocation_percent = 50.0
		civilian_allocation_percent = 30.0
		security_allocation_percent = 10.0
		scientific_allocation_percent = 10.0
		return
	var scale := 100.0 / total
	industrial_allocation_percent *= scale
	civilian_allocation_percent *= scale
	security_allocation_percent *= scale
	scientific_allocation_percent *= scale


func grow_population(delta: float) -> void:
	population += POPULATION_GROWTH_PER_SECOND * delta


func energy_production_per_second() -> float:
	return BASE_ENERGY_PRODUCTION_PER_SECOND + industrial_workforce_count() * 0.05


func energy_consumption_per_second() -> float:
	var scrap_effective := float(scrap_yard_level * scrap_yard_count) * scrap_yard_milestone_multiplier().to_float()
	var depot_effective := reclamation_depot.total_effectiveness().to_float()
	var workshop_effective := workshop.total_effectiveness().to_float()
	var factory_effective := factory.total_effectiveness().to_float()
	return BASE_CIVILIAN_ENERGY_CONSUMPTION_PER_SECOND \
		+ scrap_effective * SCRAP_YARD_ENERGY_PER_EFFECTIVE_OPERATION \
		+ depot_effective * RECLAMATION_DEPOT_ENERGY_PER_EFFECTIVE_OPERATION \
		+ workshop_effective * WORKSHOP_ENERGY_PER_EFFECTIVE_OPERATION \
		+ factory_effective * FACTORY_ENERGY_PER_EFFECTIVE_OPERATION


func energy_balance_per_second() -> float:
	return energy_production_per_second() - energy_consumption_per_second()


func energy_production_multiplier() -> float:
	var production := energy_production_per_second()
	var consumption := energy_consumption_per_second()
	if consumption <= 0.0 or production >= consumption:
		return 1.0
	var shortage_ratio := production / consumption
	match energy_priority:
		"Industrial": return clamp(shortage_ratio, 0.0, 1.0)
		"Civilian": return clamp(shortage_ratio + 0.10, 0.0, 1.0)
		"Security": return clamp(shortage_ratio + 0.05, 0.0, 1.0)
		"Scientific": return clamp(shortage_ratio + 0.05, 0.0, 1.0)
	return clamp(shortage_ratio, 0.0, 1.0)


func process_energy(delta: float) -> void:
	energy += energy_balance_per_second() * delta
	energy = max(0.0, energy)


func energy_shortage_state() -> String:
	var production := energy_production_per_second()
	var consumption := energy_consumption_per_second()
	if consumption <= production:
		return "STABLE"
	var ratio := production / consumption
	if ratio >= 0.75:
		return "STRAINED"
	if ratio >= 0.50:
		return "SHORTAGE"
	return "CRITICAL"


func set_energy_priority(priority: String) -> void:
	if ["Industrial", "Civilian", "Security", "Scientific"].has(priority):
		energy_priority = priority


func scrap_yard_level_up_cost() -> BigNumber:
	return BigNumber.from_float(LEVEL_UP_BASE_COST).multiply(BigNumber.from_float(LEVEL_UP_COST_GROWTH).pow_int(scrap_yard_level - 1))


func scrap_yard_build_new_cost() -> BigNumber:
	return BigNumber.from_float(BUILD_NEW_BASE_COST).multiply(BigNumber.from_float(BUILD_NEW_COST_GROWTH).pow_int(scrap_yard_count - 1))


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
	scrap_yard_count += 1
	return true


func produce_materials(amount: BigNumber) -> void:
	materials = materials.add(amount)
	total_materials_produced = total_materials_produced.add(amount)
