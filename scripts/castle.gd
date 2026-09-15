class_name Castle
extends Node2D

signal health_changed(current: float, maximum: float)
signal destroyed

@export var max_health: float = 1000.0
@export var armor: float = 0.0
@export var health_regen: float = 0.0

var health: float
var destroyed_flag: bool = false

func _ready() -> void:
	health = max_health
	health_changed.emit(health, max_health)

func take_damage(amount: float) -> void:
	if destroyed_flag:
		return
	var damage := maxf(amount - armor, 0.0)
	health = maxf(health - damage, 0.0)
	health_changed.emit(health, max_health)
	if health <= 0.0:
		destroy()

func heal(amount: float) -> void:
	if destroyed_flag:
		return
	health = minf(health + maxf(amount, 0.0), max_health)
	health_changed.emit(health, max_health)

func _process(delta: float) -> void:
	if not destroyed_flag and health_regen > 0.0:
		heal(health_regen * delta)

func destroy() -> void:
	if destroyed_flag:
		return
	destroyed_flag = true
	destroyed.emit()
	if GameState.is_game_active():
		GameState.end_game()
