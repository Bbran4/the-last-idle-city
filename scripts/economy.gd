extends Node

signal coins_changed(amount: int)

var coins: int = 0
var total_coins_earned: int = 0

func add_coins(amount: int) -> void:
	if amount <= 0:
		return
	coins += amount
	total_coins_earned += amount
	coins_changed.emit(coins)

func can_spend(amount: int) -> bool:
	return amount >= 0 and coins >= amount

func spend_coins(amount: int) -> bool:
	if not can_spend(amount):
		return false
	coins -= amount
	coins_changed.emit(coins)
	return true

func get_coins() -> int:
	return coins

func get_total_coins_earned() -> int:
	return total_coins_earned
