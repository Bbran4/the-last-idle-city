class_name ProductionOperation
extends Resource

const MILESTONE_INTERVAL := 10
const LEVEL_COST_GROWTH := 1.25   # was 1.15
const BUILD_COST_GROWTH := 15.0   # was 1.6	

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


func unlock_cost() -> BigNumber:
	return BigNumber.from_float(unlock_cost_base)


func milestone_multiplier() -> BigNumber:
	return BigNumber.from_float(2.0).pow_int(int(level / MILESTONE_INTERVAL))


func total_effectiveness() -> BigNumber:
	if not unlocked:
		return BigNumber.zero()
	return milestone_multiplier().multiply_float(float(level) * float(count))


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
