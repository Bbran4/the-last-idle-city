class_name ProductionOperation
extends Resource

const MILESTONE_INTERVAL := 10
const LEVEL_COST_GROWTH := 1.15
const BUILD_COST_GROWTH := 1.6

@export var display_name := "Operation"
@export var unlocked := false
@export var level := 1
@export var count := 0
@export var unlock_cost := 0.0
@export var level_up_base_cost := 0.0
@export var build_new_base_cost := 0.0


func _init(
	operation_name := "Operation",
	operation_unlock_cost := 0.0,
	operation_level_up_base_cost := 0.0,
	operation_build_new_base_cost := 0.0
) -> void:
	display_name = operation_name
	unlock_cost = operation_unlock_cost
	level_up_base_cost = operation_level_up_base_cost
	build_new_base_cost = operation_build_new_base_cost


func milestone_multiplier() -> float:
	return pow(2.0, int(level / MILESTONE_INTERVAL))


func total_effectiveness() -> float:
	if not unlocked:
		return 0.0
	return level * count * milestone_multiplier()


func level_up_cost() -> float:
	return level_up_base_cost * pow(LEVEL_COST_GROWTH, level - 1)


func build_new_cost() -> float:
	return build_new_base_cost * pow(BUILD_COST_GROWTH, count - 1)


func unlock(materials: float) -> float:
	if unlocked or materials < unlock_cost:
		return materials

	unlocked = true
	count = 1
	return materials - unlock_cost


func level_up(materials: float) -> float:
	if not unlocked or materials < level_up_cost():
		return materials

	var cost := level_up_cost()
	level += 1
	return materials - cost


func build_new(materials: float) -> float:
	if not unlocked or materials < build_new_cost():
		return materials

	var cost := build_new_cost()
	count += 1
	return materials - cost


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
