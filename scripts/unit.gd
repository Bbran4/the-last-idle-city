class_name Unit
extends Node2D

signal health_changed(current: float, maximum: float)
signal died(unit: Unit)

@export var unit_name: String = "Unit"
@export var stats: Stats

var is_dead: bool = false

func _ready() -> void:
	if stats == null:
		stats = Stats.new()
	stats.reset_health()
	health_changed.emit(stats.health, stats.max_health)

func take_damage(amount: float) -> void:
	if is_dead or stats == null:
		return
	stats.take_damage(amount)
	health_changed.emit(stats.health, stats.max_health)
	if not stats.is_alive():
		die()

func die() -> void:
	if is_dead:
		return
	is_dead = true
	died.emit(self)

func get_health_ratio() -> float:
	if stats == null or stats.max_health <= 0.0:
		return 0.0
	return stats.health / stats.max_health
