class_name Stats
extends Resource

@export_category("Health")
@export var max_health: float = 100.0
@export var health: float = 100.0

@export_category("Combat")
@export var damage: float = 10.0
@export var attack_speed: float = 1.0
@export var arrow_speed: float = 800.0
@export var range: float = 1000.0
@export var critical_chance: float = 0.05
@export var critical_damage: float = 2.0

func reset_health() -> void:
	health = max_health

func take_damage(amount: float) -> float:
	var dealt := maxf(amount, 0.0)
	health = maxf(health - dealt, 0.0)
	return dealt

func is_alive() -> bool:
	return health > 0.0

func heal(amount: float) -> float:
	var healed := clampf(amount, 0.0, max_health - health)
	health += healed
	return healed

func get_attack_interval() -> float:
	return 1.0 / maxf(attack_speed, 0.001)
