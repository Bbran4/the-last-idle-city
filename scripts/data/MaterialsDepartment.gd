class_name MaterialsDepartment
extends Department

## The Materials chain. Scrap Yard is the always-available base tier;
## Reclamation Depot, Workshop, and Factory each become visible once the
## player can afford them (see Department.is_building_visible), and each
## tier automates a fixed amount of the tier below it per second once
## unlocked - this is the cascading automation from the README's
## Milestone 4 production chain.

const MIN_SCRAP_YARD_LEVEL: int = 1

@export_group("Scrap Yard")
@export var scrap_yard_level_up_cost: float = 10.0
@export var scrap_yard_level_up_energy_cost: float = 1.0
@export var scrap_yard_build_cost: float = 1_000_000_000_000.0
@export var scrap_yard_build_energy_cost: float = 0.0
@export var scrap_yard_material_per_effective_unit: float = 1.0

@export_group("Reclamation Depot")
@export var reclamation_depot_unlock_cost: float = 100.0
@export var reclamation_depot_level_up_cost: float = 100.0
@export var reclamation_depot_level_up_energy_cost: float = 10.0
@export var reclamation_depot_build_cost: float = 10_000_000_000_000_000_000.0
@export var reclamation_depot_build_energy_cost: float = 0.0
@export var reclamation_depot_scrap_yards_per_second: float = 0.10
@export var reclamation_depot_energy_consumption_per_unit: float = 0.5

@export_group("Workshop")
@export var workshop_unlock_cost: float = 1_500.0
@export var workshop_level_up_cost: float = 300.0
@export var workshop_level_up_energy_cost: float = 10.0
@export var workshop_build_cost: float = 1_800.0
@export var workshop_build_energy_cost: float = 10.0
@export var workshop_reclamation_depots_per_second: float = 0.05
@export var workshop_energy_consumption_per_unit: float = 1.0

@export_group("Factory")
@export var factory_unlock_cost: float = 10_000.0
@export var factory_level_up_cost: float = 2_000.0
@export var factory_level_up_energy_cost: float = 20.0
@export var factory_build_cost: float = 12_000.0
@export var factory_build_energy_cost: float = 20.0
@export var factory_workshops_per_second: float = 0.025
@export var factory_energy_consumption_per_unit: float = 2.0

var scrap_yard: ProductionOperation
var reclamation_depot: ProductionOperation
var workshop: ProductionOperation
var factory: ProductionOperation

var reclamation_depot_production_progress: float = 0.0
var workshop_production_progress: float = 0.0
var factory_production_progress: float = 0.0


func _init_buildings() -> void:
	department_name = "Materials"

	scrap_yard = ProductionOperation.new("Scrap Yard", 0.0, scrap_yard_level_up_cost, scrap_yard_build_cost, scrap_yard_build_energy_cost, 1.0, 1.0)
	scrap_yard.level_up_energy_cost = scrap_yard_level_up_energy_cost
	scrap_yard.unlocked = true
	scrap_yard.count = 1
	scrap_yard.level = MIN_SCRAP_YARD_LEVEL

	reclamation_depot = ProductionOperation.new("Reclamation Depot", reclamation_depot_unlock_cost, reclamation_depot_level_up_cost, reclamation_depot_build_cost, reclamation_depot_build_energy_cost, 1.0)
	reclamation_depot.level_up_energy_cost = reclamation_depot_level_up_energy_cost

	workshop = ProductionOperation.new("Workshop", workshop_unlock_cost, workshop_level_up_cost, workshop_build_cost, workshop_build_energy_cost)
	workshop.level_up_energy_cost = workshop_level_up_energy_cost

	factory = ProductionOperation.new("Factory", factory_unlock_cost, factory_level_up_cost, factory_build_cost, factory_build_energy_cost)
	factory.level_up_energy_cost = factory_level_up_energy_cost

	buildings = [scrap_yard, reclamation_depot, workshop, factory]
	reclamation_depot_production_progress = 0.0
	workshop_production_progress = 0.0
	factory_production_progress = 0.0


func ensure_minimums() -> void:
	scrap_yard.level = max(MIN_SCRAP_YARD_LEVEL, scrap_yard.level)


## Workshop requires the Reclamation Depot to have hit its first
## milestone; Factory requires the same of Workshop. Everything else
## (Reclamation Depot itself) just needs department_unlocked + Materials,
## handled by the base class.
func _unlock_requirement_met(operation: ProductionOperation) -> bool:
	if operation == workshop:
		return reclamation_depot.unlocked and reclamation_depot.milestones_triggered >= 1
	if operation == factory:
		return workshop.unlocked and workshop.milestones_triggered >= 1
	return true


func scrap_yard_production_per_second() -> BigNumber:
	ensure_minimums()
	return scrap_yard.total_effectiveness().multiply_float(scrap_yard_material_per_effective_unit * GameState.data.industrial_authority_efficiency())


func reclamation_depot_scrap_yard_rate() -> float:
	return reclamation_depot.total_effectiveness().to_float() * reclamation_depot_scrap_yards_per_second * GameState.data.power_supply_ratio()


func workshop_reclamation_depot_rate() -> float:
	return workshop.total_effectiveness().to_float() * workshop_reclamation_depots_per_second * GameState.data.power_supply_ratio()


func factory_workshop_rate() -> float:
	return factory.total_effectiveness().to_float() * factory_workshops_per_second * GameState.data.power_supply_ratio()


func energy_consumption_per_second() -> float:
	var consumption := 0.0
	if reclamation_depot.unlocked:
		consumption += float(reclamation_depot.count) * reclamation_depot_energy_consumption_per_unit
	if workshop.unlocked:
		consumption += float(workshop.count) * workshop_energy_consumption_per_unit
	if factory.unlocked:
		consumption += float(factory.count) * factory_energy_consumption_per_unit
	return consumption


func process(delta: float) -> void:
	ensure_minimums()
	GameState.data.produce_materials(scrap_yard_production_per_second().multiply_float(delta))

	if reclamation_depot.unlocked:
		reclamation_depot_production_progress += reclamation_depot_scrap_yard_rate() * delta
		var scrap_yard_levels_to_add: int = int(floor(reclamation_depot_production_progress))
		if scrap_yard_levels_to_add > 0:
			scrap_yard.level += scrap_yard_levels_to_add
			reclamation_depot_production_progress -= float(scrap_yard_levels_to_add)

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

	ensure_minimums()


func save_data() -> Dictionary:
	var data: Dictionary = super.save_data()
	data["reclamation_depot_production_progress"] = reclamation_depot_production_progress
	data["workshop_production_progress"] = workshop_production_progress
	data["factory_production_progress"] = factory_production_progress
	return data


func load_save_data(data: Dictionary) -> void:
	super.load_save_data(data)
	reclamation_depot_production_progress = max(0.0, float(data.get("reclamation_depot_production_progress", 0.0)))
	workshop_production_progress = max(0.0, float(data.get("workshop_production_progress", 0.0)))
	factory_production_progress = max(0.0, float(data.get("factory_production_progress", 0.0)))
