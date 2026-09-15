class_name UpgradeManager
extends Node

signal passive_unlocked(display_name: String)

const FIRST_PASSIVE_COINS: int = 6
const FIRST_PASSIVE_DAMAGE_BONUS: float = 1.0

var player: Player
var first_passive_unlocked: bool = false

func setup(target_player: Player) -> void:
	player = target_player
	first_passive_unlocked = false
	Economy.coins_changed.connect(_on_coins_changed)
	_check_first_passive()

func _exit_tree() -> void:
	if Economy.coins_changed.is_connected(_on_coins_changed):
		Economy.coins_changed.disconnect(_on_coins_changed)

func _on_coins_changed(_amount: int) -> void:
	_check_first_passive()

func _check_first_passive() -> void:
	if first_passive_unlocked or player == null:
		return
	if Economy.total_coins_earned < FIRST_PASSIVE_COINS:
		return

	first_passive_unlocked = true
	player.stats.damage += FIRST_PASSIVE_DAMAGE_BONUS
	passive_unlocked.emit("Sharpened Arrows")

func is_first_passive_unlocked() -> bool:
	return first_passive_unlocked

func get_first_passive_text() -> String:
	if first_passive_unlocked:
		return "Passive: Sharpened Arrows (+1 Damage)"
	return "Passive: Locked (earn 6 coins)"
