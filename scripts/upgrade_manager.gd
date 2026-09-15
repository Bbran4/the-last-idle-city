class_name UpgradeManager
extends Node

signal passive_unlocked(display_name: String)
signal upgrades_changed

const FIRST_PASSIVE_COINS: int = 6
const FIRST_PASSIVE_DAMAGE_BONUS: float = 1.0
const DAMAGE_UPGRADE_COST: int = 1
const DAMAGE_UPGRADE_BONUS: float = 1.0
const ATTACK_SPEED_UPGRADE_COST: int = 2
const ATTACK_SPEED_UPGRADE_BONUS: float = 0.1
const CRITICAL_CHANCE_UPGRADE_COST: int = 3
const CRITICAL_CHANCE_UPGRADE_BONUS: float = 0.05
const CRITICAL_DAMAGE_UPGRADE_COST: int = 4
const CRITICAL_DAMAGE_UPGRADE_BONUS: float = 0.5

var player: Player
var first_passive_unlocked: bool = false
var damage_upgrades: int = 0
var attack_speed_upgrades: int = 0
var critical_chance_upgrades: int = 0
var critical_damage_upgrades: int = 0

func setup(target_player: Player) -> void:
	player = target_player
	first_passive_unlocked = false
	damage_upgrades = 0
	attack_speed_upgrades = 0
	critical_chance_upgrades = 0
	critical_damage_upgrades = 0
	if not Economy.coins_changed.is_connected(_on_coins_changed):
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
	upgrades_changed.emit()

func buy_damage_upgrade() -> bool:
	if player == null or not Economy.spend_coins(DAMAGE_UPGRADE_COST):
		return false

	player.stats.damage += DAMAGE_UPGRADE_BONUS
	damage_upgrades += 1
	upgrades_changed.emit()
	return true

func buy_attack_speed_upgrade() -> bool:
	if player == null or not Economy.spend_coins(ATTACK_SPEED_UPGRADE_COST):
		return false

	player.stats.attack_speed += ATTACK_SPEED_UPGRADE_BONUS
	attack_speed_upgrades += 1
	upgrades_changed.emit()
	return true

func buy_critical_chance_upgrade() -> bool:
	if player == null or not Economy.spend_coins(CRITICAL_CHANCE_UPGRADE_COST):
		return false

	player.stats.critical_chance += CRITICAL_CHANCE_UPGRADE_BONUS
	critical_chance_upgrades += 1
	upgrades_changed.emit()
	return true

func buy_critical_damage_upgrade() -> bool:
	if player == null or not Economy.spend_coins(CRITICAL_DAMAGE_UPGRADE_COST):
		return false

	player.stats.critical_damage += CRITICAL_DAMAGE_UPGRADE_BONUS
	critical_damage_upgrades += 1
	upgrades_changed.emit()
	return true

func is_first_passive_unlocked() -> bool:
	return first_passive_unlocked

func get_first_passive_text() -> String:
	if first_passive_unlocked:
		return "Passive: Sharpened Arrows (+1 Damage)"
	return "Passive: Locked (earn 6 coins)"

func get_damage_upgrade_text() -> String:
	return "Damage +1  |  Cost: %d coin" % DAMAGE_UPGRADE_COST

func get_attack_speed_upgrade_text() -> String:
	return "Attack Speed +%.1f  |  Cost: %d coins" % [ATTACK_SPEED_UPGRADE_BONUS, ATTACK_SPEED_UPGRADE_COST]

func get_critical_chance_upgrade_text() -> String:
	return "Crit Chance +%d%%  |  Cost: %d coins" % [int(CRITICAL_CHANCE_UPGRADE_BONUS * 100.0), CRITICAL_CHANCE_UPGRADE_COST]

func get_critical_damage_upgrade_text() -> String:
	return "Crit Damage +%.1fx  |  Cost: %d coins" % [CRITICAL_DAMAGE_UPGRADE_BONUS, CRITICAL_DAMAGE_UPGRADE_COST]
