class_name PlayerEconomy
extends RefCounted

const STARTING_MONEY: int = 250
const TRAINING_MANUAL_BASE_COST: int = 125
const TRAINING_MANUAL_COST_GROWTH: int = 125
const MAX_TRAINING_MANUAL_LEVEL: int = 5
const TRAINING_MANUAL_XP_BONUS: float = 0.10

var money: int = STARTING_MONEY
var training_manual_level: int = 0

func _init() -> void:
	var data: Dictionary = SaveGame.load_data()
	money = max(0, int(data.get("money", STARTING_MONEY)))
	training_manual_level = clamp(int(data.get("training_manual_level", 0)), 0, MAX_TRAINING_MANUAL_LEVEL)

func get_training_manual_cost() -> int:
	return TRAINING_MANUAL_BASE_COST + training_manual_level * TRAINING_MANUAL_COST_GROWTH

func get_xp_multiplier() -> float:
	return 1.0 + float(training_manual_level) * TRAINING_MANUAL_XP_BONUS

func can_buy_training_manual() -> bool:
	return training_manual_level < MAX_TRAINING_MANUAL_LEVEL and money >= get_training_manual_cost()

func buy_training_manual() -> bool:
	if not can_buy_training_manual():
		return false

	money -= get_training_manual_cost()
	training_manual_level += 1
	_save()
	return true

func add_money(amount: int) -> void:
	if amount <= 0:
		return
	money += amount
	_save()

func spend_money(amount: int) -> bool:
	if amount <= 0 or money < amount:
		return false
	money -= amount
	_save()
	return true

func _save() -> void:
	var data: Dictionary = SaveGame.load_data()
	data["money"] = money
	data["training_manual_level"] = training_manual_level
	SaveGame.save_data(data)

## Tournament systems will use this as the primary long-term money source.
func award_tournament_reward(amount: int) -> void:
	add_money(amount)
