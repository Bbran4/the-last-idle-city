extends Node

const TRAINING_MANUAL_BASE_COST: int = 125
const TRAINING_MANUAL_COST_GROWTH: int = 125
const MAX_TRAINING_MANUAL_LEVEL: int = 5
const TRAINING_MANUAL_XP_BONUS: float = 0.10
var training_manual_level: int = 0

func _ready() -> void:
	var data: Dictionary = SaveGame.load_data()
	training_manual_level = clamp(int(data.get("training_manual_level", 0)), 0, MAX_TRAINING_MANUAL_LEVEL)
func get_training_manual_cost() -> int:
	return TRAINING_MANUAL_BASE_COST + training_manual_level * TRAINING_MANUAL_COST_GROWTH
func get_xp_multiplier() -> float:
	return 1.0 + float(training_manual_level) * TRAINING_MANUAL_XP_BONUS
func can_buy_training_manual() -> bool:
	return training_manual_level < MAX_TRAINING_MANUAL_LEVEL and Economy.money >= get_training_manual_cost()
func buy_training_manual() -> bool:
	var cost: int = get_training_manual_cost()
	if not can_buy_training_manual() or not Economy.spend_money(cost):
		return false
	training_manual_level += 1
	_save()
	return true
func get_trajectory_prediction_quality() -> float:
	if Stats.accuracy_level < 2:
		return 0.0
	return clamp(float(Stats.accuracy_level - 1) / 19.0, 0.0, 1.0)
func get_quick_shot_accuracy() -> float:
	return clamp(float(Stats.accuracy_level) / float(Stats.MAX_LEVEL), 0.0, 1.0)
func _save() -> void:
	var data: Dictionary = SaveGame.load_data()
	data["training_manual_level"] = training_manual_level
	SaveGame.save_data(data)
