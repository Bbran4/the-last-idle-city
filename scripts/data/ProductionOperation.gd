class_name ProductionOperation
extends Resource

const DEFAULT_BUILD_COST_GROWTH: float = 15.0
const MILESTONE_LEVELS: Array[int] = [10, 25, 100, 500, 1_000, 10_000, 50_000]
const FIRST_MILESTONE_LEVEL: int = 10

@export var display_name: String = "Production Unit"
@export var unlocked: bool = false
@export var level: int = 1
@export var count: int = 0
@export var unlock_cost_base: float = 0.0
@export var level_up_base_cost: float = 0.0
@export var level_up_energy_cost: float = 0.0
@export var build_new_base_cost: float = 0.0
@export var build_cost_growth: float = DEFAULT_BUILD_COST_GROWTH
@export var build_new_energy_cost: float = 0.0
@export var milestones_triggered: int = 0
## When set, this operation's unlock/level-up costs are paid by
## consuming LEVELS from another operation instead of the shared
## Materials pool.
@export var cost_source: ProductionOperation = null

func _init(
	operation_name: String = "Production Unit",
	operation_unlock_cost: float = 0.0,
	operation_level_up_base_cost: float = 0.0,
	operation_build_new_base_cost: float = 0.0,
	operation_build_new_energy_cost: float = 0.0,
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

static func milestones_reached_at_level(level_value: int) -> int:
	var reached: int = 0
	while reached < MILESTONE_LEVELS.size() and level_value >= milestone_level_at(reached):
		reached += 1
	if reached >= MILESTONE_LEVELS.size():
		var next_level: int = milestone_level_at(reached)
		while level_value >= next_level:
			reached += 1
			next_level = milestone_level_at(reached)
	return reached

static func milestone_multiplier_for_count(count_value: int) -> BigNumber:
	return BigNumber.from_float(2.0).pow_int(count_value)

func milestone_multiplier() -> BigNumber:
	return milestone_multiplier_for_count(milestones_reached_at_level(level))

func next_milestone_level() -> int:
	return milestone_level_at(milestones_reached_at_level(level))

func production_per_building() -> BigNumber:
	if not unlocked or count <= 0:
		return BigNumber.zero()
	return BigNumber.from_float(float(level)).multiply(milestone_multiplier())

func total_effectiveness() -> BigNumber:
	if not unlocked:
		return BigNumber.zero()
	return production_per_building().multiply_float(float(count))

func unlock_cost() -> BigNumber:
	return BigNumber.from_float(unlock_cost_base)

func level_up_cost() -> BigNumber:
	return BigNumber.from_float(level_up_base_cost)

func build_new_cost() -> BigNumber:
	return BigNumber.from_float(build_new_base_cost).multiply(
		BigNumber.from_float(build_cost_growth).pow_int(max(0, count - 1))
	)

func can_build_new(materials: BigNumber, current_energy: float) -> bool:
	return unlocked and materials.is_greater_or_equal(build_new_cost()) and current_energy >= build_new_energy_cost

func build_new(materials: BigNumber, current_energy: float) -> Dictionary:
	var cost: BigNumber = build_new_cost()
	if not unlocked or materials.is_less_than(cost) or current_energy < build_new_energy_cost:
		return {"success": false, "materials": materials, "energy": current_energy}
	count += 1
	return {
		"success": true,
		"materials": materials.subtract(cost),
		"energy": current_energy - build_new_energy_cost
	}

## Milestones are automatic. Reaching the required level immediately
## increases the production multiplier. There is no currency or energy
## cost and the level is never reduced when a milestone is reached.
func can_trigger_milestone() -> bool:
	return false

func trigger_milestone() -> Dictionary:
	return {"success": false}

func unlock(materials: BigNumber) -> BigNumber:
	if unlocked:
		return materials
	if cost_source != null:
		if not can_afford_unlock_from_source():
			return materials
		_spend_cost_source(unlock_cost())
		unlocked = true
		count = 1
		level = max(1, level)
		return materials
	if materials.is_less_than(unlock_cost()):
		return materials
	unlocked = true
	count = 1
	level = max(1, level)
	return materials.subtract(unlock_cost())

func level_up(materials: BigNumber) -> BigNumber:
	if not unlocked:
		return materials
	if cost_source != null:
		if not can_afford_level_up_from_source():
			return materials
		_spend_cost_source(level_up_cost())
		level = max(1, level + 1)
		return materials
	if materials.is_less_than(level_up_cost()):
		return materials
	var cost: BigNumber = level_up_cost()
	level = max(1, level + 1)
	return materials.subtract(cost)

func _spend_cost_source(cost: BigNumber) -> void:
	if cost_source == null:
		return
	var cost_value: int = int(floor(cost.to_float()))
	if cost_value <= 0:
		return
	cost_source.level = max(1, cost_source.level - cost_value)

func source_levels_required_for_level_ups(level_count: int) -> int:
	if cost_source == null or level_count <= 0 or level_up_base_cost <= 0.0:
		return 0
	return int(ceil(level_up_base_cost * float(level_count)))

func can_afford_unlock_from_source() -> bool:
	if cost_source == null:
		return false
	var required: int = int(ceil(unlock_cost_base))
	return required > 0 and cost_source.level >= required

func can_afford_level_up_from_source() -> bool:
	if cost_source == null:
		return false
	var required: int = int(ceil(level_up_base_cost))
	return required > 0 and cost_source.level >= required

func max_purchasable_levels(currency: BigNumber, available_energy: float, max_levels: int = -1) -> int:
	if not unlocked:
		return 0
	if level_up_base_cost <= 0.0:
		return max_levels if max_levels >= 0 else 0

	var currency_limit: int = int(floor(currency.to_float() / level_up_base_cost))
	var affordable: int = max(0, currency_limit)

	if level_up_energy_cost > 0.0:
		var energy_limit: int = int(floor(max(0.0, available_energy) / level_up_energy_cost))
		affordable = min(affordable, max(0, energy_limit))

	if cost_source != null:
		affordable = min(affordable, int(floor(float(cost_source.level) / level_up_base_cost)))

	if max_levels >= 0:
		affordable = min(affordable, max_levels)

	return affordable

func total_level_up_cost(levels: int) -> BigNumber:
	if levels <= 0 or level_up_base_cost <= 0.0:
		return BigNumber.zero()
	return BigNumber.from_float(level_up_base_cost).multiply_float(float(levels))

func save_data() -> Dictionary:
	return {
		"unlocked": unlocked,
		"level": level,
		"count": count,
		"milestones_triggered": milestones_reached_at_level(level)
	}

func load_save_data(data: Dictionary) -> void:
	unlocked = bool(data.get("unlocked", false))
	level = max(1, int(data.get("level", 1)))
	count = max(0, int(data.get("count", 0)))
	milestones_triggered = milestones_reached_at_level(level)
	if unlocked and count == 0:
		count = 1
