class_name WaveManager
extends Node

signal wave_started(wave: int)
signal wave_completed(wave: int)
signal intermission_started(wave: int, duration: float)
signal intermission_ended(wave: int)
signal boss_spawned(boss: Enemy)
signal boss_defeated(boss: Enemy)

const MINI_BOSS_INTERVAL: int = 5
const MINI_BOSS_HEALTH_MULTIPLIER: float = 10.0
const MINI_BOSS_REWARD: int = 10
const MINI_BOSS_MOVEMENT_SPEED: float = 45.0
const MINI_BOSS_CASTLE_DAMAGE: float = 25.0
const MAJOR_BOSS_INTERVAL: int = 10
const MAJOR_BOSS_HEALTH_MULTIPLIER: float = 20.0
const MAJOR_BOSS_REWARD: int = 25
const MAJOR_BOSS_MOVEMENT_SPEED: float = 40.0
const MAJOR_BOSS_CASTLE_DAMAGE: float = 40.0

@export var enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")
@export var starting_wave: int = 1
@export var enemies_per_wave: int = 5
@export var enemy_count_growth: int = 1
@export var wave_break: float = 5.0
@export var spawn_distance: float = 900.0
@export var horizontal_stagger: float = 90.0

var current_wave: int = 0
var active_enemies: int = 0
var target_castle: Castle
var wave_timer: float = 0.0
var waiting_for_next_wave: bool = false
var started: bool = false

func setup(castle: Castle) -> void:
	target_castle = castle

func start() -> void:
	if started or target_castle == null or enemy_scene == null:
		return
	started = true
	waiting_for_next_wave = false
	start_next_wave()

func _process(delta: float) -> void:
	if not started or not GameState.is_game_active():
		return

	if waiting_for_next_wave:
		wave_timer -= delta
		if wave_timer <= 0.0:
			waiting_for_next_wave = false
			intermission_ended.emit(current_wave)
			start_next_wave()

func is_intermission() -> bool:
	return waiting_for_next_wave

func get_intermission_time_remaining() -> float:
	return maxf(wave_timer, 0.0)

func start_next_wave() -> void:
	if target_castle == null or enemy_scene == null or not GameState.is_game_active():
		return

	current_wave = max(current_wave + 1, starting_wave)
	active_enemies = 0
	wave_started.emit(current_wave)
	GameState.set_wave(current_wave)

	var enemy_count := enemies_for_wave(current_wave)
	for i in enemy_count:
		_spawn_enemy(i, enemy_count)

	if is_major_boss_wave(current_wave):
		_spawn_major_boss()
	elif is_mini_boss_wave(current_wave):
		_spawn_mini_boss()

func enemies_for_wave(wave: int) -> int:
	return max(enemies_per_wave + ((wave - 1) * enemy_count_growth), 1)

func is_mini_boss_wave(wave: int) -> bool:
	return wave > 0 and wave % MINI_BOSS_INTERVAL == 0

func is_major_boss_wave(wave: int) -> bool:
	return wave > 0 and wave % MAJOR_BOSS_INTERVAL == 0

func _spawn_enemy(index: int, total: int) -> void:
	var enemy := enemy_scene.instantiate() as Enemy
	if enemy == null:
		return

	get_tree().current_scene.add_child(enemy)
	enemy.add_to_group("enemies")
	enemy.died.connect(_on_enemy_died)

	var side := -1.0 if index % 2 == 0 else 1.0
	var stagger: float = floor(float(index) / 2.0) * horizontal_stagger
	var spawn_x: float = target_castle.global_position.x + side * (spawn_distance + stagger)
	enemy.global_position = Vector2(spawn_x, target_castle.get_ground_y())

	var enemy_stats := Stats.new()
	var health_scale := 1.0 + ((current_wave - 1) * 0.15)
	enemy_stats.max_health = 1.0 * health_scale
	enemy_stats.health = enemy_stats.max_health
	enemy.setup(target_castle, enemy_stats)
	active_enemies += 1

func _spawn_mini_boss() -> void:
	var boss := enemy_scene.instantiate() as Enemy
	if boss == null:
		return

	get_tree().current_scene.add_child(boss)
	boss.add_to_group("enemies")
	boss.died.connect(_on_boss_died)
	boss.global_position = Vector2(target_castle.global_position.x - spawn_distance, target_castle.get_ground_y())
	boss.is_boss = true
	boss.is_major_boss = false
	boss.coin_reward = MINI_BOSS_REWARD
	boss.movement_speed = MINI_BOSS_MOVEMENT_SPEED
	boss.castle_damage = MINI_BOSS_CASTLE_DAMAGE

	var boss_stats := Stats.new()
	var health_scale := 1.0 + ((current_wave - 1) * 0.15)
	boss_stats.max_health = 3.0 * health_scale * MINI_BOSS_HEALTH_MULTIPLIER
	boss_stats.health = boss_stats.max_health
	boss.setup(target_castle, boss_stats)
	active_enemies += 1
	boss_spawned.emit(boss)

func _spawn_major_boss() -> void:
	var boss := enemy_scene.instantiate() as Enemy
	if boss == null:
		return

	get_tree().current_scene.add_child(boss)
	boss.add_to_group("enemies")
	boss.died.connect(_on_boss_died)
	boss.global_position = Vector2(target_castle.global_position.x - spawn_distance, target_castle.get_ground_y())
	boss.is_boss = true
	boss.is_major_boss = true
	boss.coin_reward = MAJOR_BOSS_REWARD
	boss.movement_speed = MAJOR_BOSS_MOVEMENT_SPEED
	boss.castle_damage = MAJOR_BOSS_CASTLE_DAMAGE

	var boss_stats := Stats.new()
	var health_scale := 1.0 + ((current_wave - 1) * 0.15)
	boss_stats.max_health = 3.0 * health_scale * MAJOR_BOSS_HEALTH_MULTIPLIER
	boss_stats.health = boss_stats.max_health
	boss.setup(target_castle, boss_stats)
	active_enemies += 1
	boss_spawned.emit(boss)

func _on_enemy_died(_enemy: Unit) -> void:
	active_enemies = max(active_enemies - 1, 0)
	_check_wave_complete()

func _on_boss_died(boss: Unit) -> void:
	active_enemies = max(active_enemies - 1, 0)
	boss_defeated.emit(boss as Enemy)
	_check_wave_complete()

func _check_wave_complete() -> void:
	if active_enemies == 0 and current_wave > 0 and not waiting_for_next_wave and GameState.is_game_active():
		wave_completed.emit(current_wave)
		waiting_for_next_wave = true
		wave_timer = wave_break
		intermission_started.emit(current_wave, wave_break)
