class_name Enemy
extends Unit

signal reached_castle(damage: float)
signal boss_health_changed(current: float, maximum: float)
signal boss_phase_changed(phase_name: String)

const BOSS_ENRAGE_HEALTH_RATIO: float = 0.5
const BOSS_ENRAGED_SPEED: float = 80.0
const BOSS_ENRAGED_CASTLE_DAMAGE: float = 35.0

@export var coin_reward: int = 1
@export var movement_speed: float = 80.0
@export var castle_damage: float = 10.0

@onready var health_bar: ProgressBar = get_node_or_null("HealthBar")

var target_castle: Castle
var feedback_tween: Tween
var is_boss: bool = false
var boss_enraged: bool = false

func setup(castle: Castle, enemy_stats: Stats) -> void:
	target_castle = castle
	stats = enemy_stats.duplicate(true)
	is_dead = false
	boss_enraged = false
	scale = Vector2.ONE
	modulate = Color.WHITE
	_setup_health_bar()
	health_changed.emit(stats.health, stats.max_health)
	if is_boss:
		boss_health_changed.emit(stats.health, stats.max_health)

func _setup_health_bar() -> void:
	if health_bar == null or stats == null:
		return
	health_bar.max_value = stats.max_health
	health_bar.value = stats.health
	health_bar.visible = false

func _show_health_bar() -> void:
	if health_bar == null or stats == null or is_dead:
		return
	health_bar.max_value = stats.max_health
	health_bar.value = stats.health
	health_bar.visible = true

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
	if is_boss:
		boss_health_changed.emit(stats.health, stats.max_health)
		_check_boss_enrage()
	if is_dead:
		Economy.add_coins(coin_reward)
	else:
		_show_health_bar()
		_play_hit_feedback()

func _check_boss_enrage() -> void:
	if not is_boss or boss_enraged or stats.health <= 0.0:
		return
	if stats.health > stats.max_health * BOSS_ENRAGE_HEALTH_RATIO:
		return

	boss_enraged = true
	movement_speed = BOSS_ENRAGED_SPEED
	castle_damage = BOSS_ENRAGED_CASTLE_DAMAGE
	boss_phase_changed.emit("ENRAGED")
	_play_boss_enrage_feedback()

func _play_hit_feedback() -> void:
	if feedback_tween and feedback_tween.is_valid():
		feedback_tween.kill()
	modulate = Color(1.0, 0.45, 0.45, 1.0)
	feedback_tween = create_tween()
	feedback_tween.tween_property(self, "modulate", Color.WHITE, 0.08)

func _play_boss_enrage_feedback() -> void:
	if feedback_tween and feedback_tween.is_valid():
		feedback_tween.kill()
	var enrage_tween := create_tween()
	enrage_tween.set_parallel(true)
	enrage_tween.tween_property(self, "scale", Vector2.ONE * 1.85, 0.12)
	enrage_tween.tween_property(self, "modulate", Color(1.0, 0.55, 0.2, 1.0), 0.12)
	enrage_tween.chain().set_parallel(true)
	enrage_tween.tween_property(self, "scale", Vector2.ONE * 1.6, 0.18)
	enrage_tween.tween_property(self, "modulate", Color(1.0, 0.75, 0.45, 1.0), 0.18)

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
	if health_bar:
		health_bar.visible = false
	died.emit(self)
	if feedback_tween and feedback_tween.is_valid():
		feedback_tween.kill()
	var death_tween := create_tween()
	death_tween.set_parallel(true)
	death_tween.tween_property(self, "scale", Vector2(0.55, 0.55), 0.12)
	death_tween.tween_property(self, "modulate:a", 0.0, 0.12)
	death_tween.chain().tween_callback(queue_free)
