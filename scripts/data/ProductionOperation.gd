class_name ProductionOperation
extends Resource

const LEVEL_COST_GROWTH := 1.25
const BUILD_COST_GROWTH := 15.0

## Explicit milestone levels, in order. Each one crossed doubles the
## operation's productivity multiplier (see milestone_multiplier_for_level).
const MILESTONE_LEVELS: Array[int] = [10, 25, 50, 100, 200, 500, 1000, 10000, 50000]

## Past the last explicit entry above, milestones keep generating by
## multiplying the previous one by this much. Currently set to match
## the ratio between the last two explicit entries (10,000 -> 50,000 = x5).
## ASSUMPTION — confirm this is the intended long-term pattern.
const MILESTONE_GENERATED_GROWTH := 5.0

## Matches MILESTONE_LEVELS[0]. Kept as its own constant because it's
## referenced as a plain int for tier-unlock requirements (e.g. Workshop
## requires Reclamation Depot to have crossed the first milestone).
const FIRST_MILESTONE_LEVEL := 10

@export var display_name := "Operation"
@export var unlocked := false
@export var level := 1
@export var count := 0
@export var unlock_cost_base := 0.0
@export var level_up_base_cost := 0.0
@export var build_new_base_cost := 0.0


func _init(
	operation_name := "Operation",
	operation_unlock_cost := 0.0,
	operation_level_up_base_cost := 0.0,
	operation_build_new_base_cost := 0.0
) -> void:
	display_name = operation_name
	unlock_cost_base = operation_unlock_cost
	level_up_base_cost = operation_level_up_base_cost
	build_new_base_cost = operation_build_new_base_cost


## Returns the level threshold for the Nth milestone (0-indexed).
## Reads from MILESTONE_LEVELS while defined, then generates further
## thresholds indefinitely using MILESTONE_GENERATED_GROWTH.
static func milestone_level_at(index: int) -> int:
	if index < MILESTONE_LEVELS.size():
		return MILESTONE_LEVELS[index]

	var generated_steps := index - (MILESTONE_LEVELS.size() - 1)
	var last_defined := MILESTONE_LEVELS[MILESTONE_LEVELS.size() - 1]
	return int(round(last_defined * pow(MILESTONE_GENERATED_GROWTH, generated_steps)))


## How many milestones a given level has crossed.
static func milestone_count_for_level(level: int) -> int:
	var count := 0
	while level >= milestone_level_at(count):
		count += 1
	return count


## The productivity multiplier from milestones crossed so far: ×2 per milestone.
static func milestone_multiplier_for_level(level: int) -> BigNumber:
	return BigNumber.from_float(2.0).pow_int(milestone_count_for_level(level))


## The level at which the *next* milestone will be reached.
static func next_milestone_level(level: int) -> int:
	return milestone_level_at(milestone_count_for_level(level))


func milestone_multiplier() -> BigNumber:
	return milestone_multiplier_for_level(level)


func total_effectiveness() -> BigNumber:
	if not unlocked:
		return BigNumber.zero()
	return milestone_multiplier().multiply_float(float(level) * float(count))


func unlock_cost() -> BigNumber:
	return BigNumber.from_float(unlock_cost_base)


func level_up_cost() -> BigNumber:
	return BigNumber.from_float(level_up_base_cost).multiply(
		BigNumber.from_float(LEVEL_COST_GROWTH).pow_int(level - 1)
	)


func build_new_cost() -> BigNumber:
	return BigNumber.from_float(build_new_base_cost).multiply(
		BigNumber.from_float(BUILD_COST_GROWTH).pow_int(count - 1)
	)


func unlock(materials: BigNumber) -> BigNumber:
	if unlocked or materials.is_less_than(unlock_cost()):
		return materials

	unlocked = true
	count = 1
	return materials.subtract(unlock_cost())


func level_up(materials: BigNumber) -> BigNumber:
	if not unlocked or materials.is_less_than(level_up_cost()):
		return materials

	var cost := level_up_cost()
	level += 1
	return materials.subtract(cost)


func build_new(materials: BigNumber) -> BigNumber:
	if not unlocked or materials.is_less_than(build_new_cost()):
		return materials

	var cost := build_new_cost()
	count += 1
	return materials.subtract(cost)


func save_data() -> Dictionary:
	return {
		"unlocked": unlocked,
		"level": level,
		"count": count
	}


func load_save_data(data: Dictionary) -> void:
	unlocked = bool(data.get("unlocked", false))
	level = max(1, int(data.get("level", 1)))
	count = max(0, int(data.get("count", 0)))
	if unlocked and count == 0:
		count = 1
