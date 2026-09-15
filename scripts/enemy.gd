class_name Enemy
extends Unit

signal reached_castle(damage: float)

@export var coin_reward: int = 1
@export var movement_speed: float = 80.0
@export var castle_damage: float = 10.0

var target_castle: Castle
var feedback_tween: Tween

func setup(castle: Castle, enemy_stats: Stats) -> void:
	target_castle = castle
	stats = enemy_stats.duplicate(true)
	is_dead = false
	scale = Vector2.ONE
	modulate = Color.WHITE
	health_changed.emit(stats.health, stats.max_health)

func _physics_process(delta: float) -> void:
	if is_dead or target_castle == null:
		return

	if global_position.distance_to(target_castle.global_position) <= 100.0:
		reach_castle()
		return

	global_position += global_position.direction_to(target_castle.global_position) * movement_speed * delta

func take_damage(amount: float) -> void:
	if is_dead or stats == null:
		return

	super.take_damage(amount)
	if is_dead:
		Economy.add_coins(coin_reward)
	else:
		_play_hit_feedback()

func _play_hit_feedback() -> void:
	if feedback_tween and feedback_tween.is_valid():
		feedback_tween.kill()
	modulate = Color(1.0, 0.45, 0.45, 1.0)
	feedback_tween = create_tween()
	feedback_tween.tween_property(self, "modulate", Color.WHITE, 0.08)

func reach_castle() -> void:
	if is_dead:
		return
	reached_castle.emit(castle_damage)
	target_castle.take_damage(castle_damage)
	die()

func die() -> void:
	if is_dead:
		return
	is_dead = true
	died.emit(self)
	if feedback_tween and feedback_tween.is_valid():
		feedback_tween.kill()
	var death_tween := create_tween()
	death_tween.set_parallel(true)
	death_tween.tween_property(self, "scale", Vector2(0.55, 0.55), 0.12)
	death_tween.tween_property(self, "modulate:a", 0.0, 0.12)
	death_tween.chain().tween_callback(queue_free)
