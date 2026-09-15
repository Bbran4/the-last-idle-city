class_name Enemy
extends Unit

signal reached_castle(damage: float)

@export var coin_reward: int = 1
@export var movement_speed: float = 80.0
@export var castle_damage: float = 10.0

var target_castle: Castle

func setup(castle: Castle, enemy_stats: Stats) -> void:
	target_castle = castle
	stats = enemy_stats.duplicate(true)
	is_dead = false
	health_changed.emit(stats.health, stats.max_health)

func _physics_process(delta: float) -> void:
	if is_dead or target_castle == null:
		return

	if global_position.distance_to(target_castle.global_position) <= 100.0:
		reach_castle()
		return

	global_position += global_position.direction_to(target_castle.global_position) * movement_speed * delta

func reach_castle() -> void:
	if is_dead:
		return
	reached_castle.emit(castle_damage)
	target_castle.take_damage(castle_damage)
	die()
	queue_free()

func die() -> void:
	if is_dead:
		return
	is_dead = true
	died.emit(self)
	queue_free()
