class_name EnergyDepartment
extends Department

## The Energy chain. Currently a single Generator tier, built with the
## exact same Level Up / Build New / Milestone model as Scrap Yard, so
## it can grow into its own multi-tier chain later the same way the
## Materials chain grew past Scrap Yard.
##
## `department_unlocked` defaults to false: Energy "comes a bit later"
## per the design doc, so this department is fully wired up but not
## reachable by the player yet. Flip the checkbox on this node in the
## editor (or wire up a real unlock condition later, e.g. a Materials
## milestone) when Energy is meant to go live - the OperationsPanel and
## RightRail tabs for it will appear automatically once it's unlocked.

const MIN_GENERATOR_LEVEL: int = 1

## Overrides the Department base default (true) - Energy starts locked.
#@export var department_unlocked: bool = false

@export_group("Generator")
@export var generator_level_up_cost: float = 8.0
@export var generator_build_cost: float = 40.0
@export var generator_energy_per_effective_unit: float = 1.0

var generator: ProductionOperation


func _init_buildings() -> void:
	department_name = "Energy"
	department_unlocked = true   # was false — Energy is now unlocked
	generator = ProductionOperation.new("Generator", 0.0, generator_level_up_cost, generator_build_cost, 0.0, 1.0)
	generator.unlocked = true
	generator.count = 1
	generator.level = MIN_GENERATOR_LEVEL

	buildings = [generator]

## Level-ups are disabled for now, per design — Generator stays at its
## starting level until this is revisited.
func can_level_up(_operation: ProductionOperation) -> bool:
	return false

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
