class_name Economy
extends Node
signal money_changed(amount: int)
const STARTING_MONEY: int = 250
var money := STARTING_MONEY
func _ready() -> void:
	var data: Dictionary = SaveGame.load_data()
	money = max(0, int(data.get("money", STARTING_MONEY)))
func add_money(amount: int) -> void:
	if amount > 0:
		money += amount
		_save()
func spend_money(amount: int) -> bool:
	if amount <= 0 or money < amount:
		return false
	money -= amount
	_save()
	return true
func award_tournament_reward(amount: int) -> void:
	add_money(amount)
func _save() -> void:
	var data: Dictionary = SaveGame.load_data()
	data["money"] = money
	SaveGame.save_data(data)
	money_changed.emit(money)
