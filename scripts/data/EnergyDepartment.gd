class_name EnergyDepartment
extends Department

## The Energy chain. Generators use the same Level Up / Build New model
## as the other production chains, but additional generators become
## substantially more expensive as the city expands its power grid.

const MIN_GENERATOR_LEVEL: int = 1
const GENERATOR_BUILD_COST_GROWTH: float = 1.5

@export_group("Generator")
@export var generator_level_up_cost: float = 8.0
@export var generator_build_cost: float = 30_000_000.0
@export var generator_energy_per_effective_unit: float = 1.0

var generator: ProductionOperation


func _init_buildings() -> void:
	department_name = "Energy"
	department_unlocked = true
	generator = ProductionOperation.new(
		"Generator",
		0.0,
		generator_level_up_cost,
		generator_build_cost,
		0.0,
		GENERATOR_BUILD_COST_GROWTH
	)
	generator.unlocked = true
	generator.count = 1
	generator.level = MIN_GENERATOR_LEVEL

	buildings = [generator]

## Generator upgrades use the standard Department purchase flow.
## Each level costs Materials and increases the output of every
## generator. Build New adds another generator and its cost scales by
## 1.5x for each generator already owned.
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
