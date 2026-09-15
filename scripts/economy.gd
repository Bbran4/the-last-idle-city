class_name Economy
extends Node

signal coins_changed(amount: int)

var coins: int = 0

func add_coins(amount: int) -> void:
	if amount <= 0:
		return
	coins += amount
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
