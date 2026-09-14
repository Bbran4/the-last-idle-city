class_name ProductionOperation
extends Resource

const LEVEL_COST_GROWTH: float = 1.25
const DEFAULT_BUILD_COST_GROWTH: float = 15.0
const MILESTONE_ENERGY_BASE_COST: float = 1.0
const MILESTONE_ENERGY_GROWTH: float = 2.0
const MILESTONE_LEVELS: Array[int] = [10, 25, 100, 500, 1_000, 10_000, 50_000]
const FIRST_MILESTONE_LEVEL: int = 10

@export var display_name: String = "Production Unit"
@export var unlocked: bool = false
@export var level: int = 1
@export var count: int = 0
@export var unlock_cost_base: float = 0.0
@export var level_up_base_cost: float = 0.0
@export var build_new_base_cost: float = 0.0
@export var build_cost_growth: float = DEFAULT_BUILD_COST_GROWTH
@export var build_new_energy_cost: float = 1.0
@export var milestones_triggered: int = 0

func _init(
	operation_name: String = "Production Unit",
	operation_unlock_cost: float = 0.0,
	operation_level_up_base_cost: float = 0.0,
	operation_build_new_base_cost: float = 0.0,
	operation_build_new_energy_cost: float = 1.0,
	operation_build_cost_growth: float = DEFAULT_BUILD_COST_GROWTH
) -> void:
	display_name = operation_name
	unlock_cost_base = operation_unlock_cost
	level_up_base_cost = operation_level_up_base_cost
	build_new_base_cost = operation_build_new_base_cost
	build_new_energy_cost = operation_build_new_energy_cost
	build_cost_growth = operation_build_cost_growth

static func milestone_level_at(index: int) -> int:
	if index < MILESTONE_LEVELS.size():
		return MILESTONE_LEVELS[index]
	var generated_steps: int = index - (MILESTONE_LEVELS.size() - 1)
	var last_defined: int = MILESTONE_LEVELS[MILESTONE_LEVELS.size() - 1]
	return int(round(float(last_defined) * pow(5.0, generated_steps)))

static func milestone_energy_cost_at(index: int) -> float:
	return MILESTONE_ENERGY_BASE_COST * pow(MILESTONE_ENERGY_GROWTH, index)

static func milestone_multiplier_for_count(count: int) -> BigNumber:
	return BigNumber.from_float(2.0).pow_int(count)

func milestone_multiplier() -> BigNumber:
	return milestone_multiplier_for_count(milestones_triggered)

func next_milestone_level() -> int:
	return milestone_level_at(milestones_triggered)

func next_milestone_energy_cost() -> float:
	return milestone_energy_cost_at(milestones_triggered)

func total_effectiveness() -> BigNumber:
	if not unlocked:
		return BigNumber.zero()
	var effective_level: int = max(1, level)
	return BigNumber.from_float(float(effective_level * count)).multiply(milestone_multiplier())

func unlock_cost() -> BigNumber:
	return BigNumber.from_float(unlock_cost_base)

func level_up_cost() -> BigNumber:
	return BigNumber.from_float(level_up_base_cost).multiply(
		BigNumber.from_float(LEVEL_COST_GROWTH).pow_int(max(0, level))
	)

func build_new_cost() -> BigNumber:
	return BigNumber.from_float(build_new_base_cost).multiply(
		BigNumber.from_float(build_cost_growth).pow_int(max(0, count - 1))
	)

func can_build_new(materials: BigNumber, current_energy: float) -> bool:
	return unlocked and materials.is_greater_or_equal(build_new_cost()) and current_energy >= build_new_energy_cost

func build_new(materials: BigNumber, current_energy: float) -> Dictionary:
	if not can_build_new(materials, current_energy):
		return {"success": false, "materials": materials, "energy": current_energy}
	var cost: BigNumber = build_new_cost()
	count += 1
	return {"success": true, "materials": materials.subtract(cost), "energy": current_energy - build_new_energy_cost}

func can_trigger_milestone(current_energy: float) -> bool:
	return level >= next_milestone_level() and current_energy >= next_milestone_energy_cost()

func trigger_milestone(current_energy: float) -> Dictionary:
	var required_level: int = next_milestone_level()
	var energy_cost: float = next_milestone_energy_cost()
	if level < required_level or current_energy < energy_cost:
		return {"success": false, "energy": current_energy, "level": level}
	level -= required_level
	milestones_triggered += 1
	return {"success": true, "energy": current_energy - energy_cost, "level": level}

func unlock(materials: BigNumber) -> BigNumber:
	if unlocked or materials.is_less_than(unlock_cost()):
		return materials
	unlocked = true
	count = 1
	return materials.subtract(unlock_cost())

func level_up(materials: BigNumber) -> BigNumber:
	if not unlocked or materials.is_less_than(level_up_cost()):
		return materials
	var cost: BigNumber = level_up_cost()
	level += 1
	return materials.subtract(cost)

func save_data() -> Dictionary:
	return {"unlocked": unlocked, "level": level, "count": count, "milestones_triggered": milestones_triggered}

func load_save_data(data: Dictionary) -> void:
	unlocked = bool(data.get("unlocked", false))
	level = max(0, int(data.get("level", 1)))
	count = max(0, int(data.get("count", 0)))
	milestones_triggered = max(0, int(data.get("milestones_triggered", 0)))
	if unlocked and count == 0:
		count = 1
