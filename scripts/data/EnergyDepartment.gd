class_name EnergyDepartment
extends Department

## The Energy chain. Currently a single Generator tier, built with the
## exact same Level Up / Build New / Milestone model as Scrap Yard, so
## it can grow into its own multi-tier chain later the same way the
## Materials chain grew past Scrap Yard.
##
## Energy is currently available from the start. The Generator can be
## upgraded to increase the output of every generator level, additional
## generators can be built to increase total capacity, and milestones
## can double generator production.

const MIN_GENERATOR_LEVEL: int = 1

@export_group("Generator")
@export var generator_level_up_cost: float = 8.0
@export var generator_build_cost: float = 40.0
@export var generator_energy_per_effective_unit: float = 1.0

var generator: ProductionOperation


func _init_buildings() -> void:
	department_name = "Energy"
	department_unlocked = true
	generator = ProductionOperation.new("Generator", 0.0, generator_level_up_cost, generator_build_cost, 0.0, 1.0)
	generator.unlocked = true
	generator.count = 1
	generator.level = MIN_GENERATOR_LEVEL

	buildings = [generator]

## Generator upgrades use the standard Department purchase flow.
## Each level costs Materials and increases the output of every
## generator. Build New adds another generator and its cost scales
## with the number already owned.
func can_level_up(operation: ProductionOperation) -> bool:
	return super.can_level_up(operation)

func ensure_minimums() -> void:
	generator.level = max(MIN_GENERATOR_LEVEL, generator.level)
	generator.count = max(1, generator.count)


func generator_production_per_second() -> float:
	if not department_unlocked:
		return 0.0
	ensure_minimums()
	return generator.total_effectiveness().to_float() * generator_energy_per_effective_unit * GameState.data.central_government_efficiency()


func energy_production_per_second() -> float:
	return generator_production_per_second()
