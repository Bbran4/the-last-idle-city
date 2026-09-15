class_name WaveManager
extends Node

signal wave_started(wave: int)
signal wave_completed(wave: int)

@export var enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")
@export var starting_wave: int = 1
@export var enemies_per_wave: int = 5
@export var enemy_count_growth: int = 1
@export var wave_break: float = 2.0
@export var spawn_distance: float = 900.0
@export var vertical_spacing: float = 120.0

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
			start_next_wave()

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

func enemies_for_wave(wave: int) -> int:
	return max(enemies_per_wave + ((wave - 1) * enemy_count_growth), 1)

func _spawn_enemy(index: int, total: int) -> void:
	var enemy := enemy_scene.instantiate() as Enemy
	if enemy == null:
		return

	get_tree().current_scene.add_child(enemy)
	enemy.add_to_group("enemies")
	enemy.died.connect(_on_enemy_died)

	var center_offset := float(total - 1) * 0.5
	var y_offset := (float(index) - center_offset) * vertical_spacing
	var side := -1.0 if index % 2 == 0 else 1.0
	enemy.global_position = target_castle.global_position + Vector2(side * spawn_distance, y_offset)

	var enemy_stats := Stats.new()
	var health_scale := 1.0 + ((current_wave - 1) * 0.15)
	enemy_stats.max_health = 30.0 * health_scale
	enemy_stats.health = enemy_stats.max_health
	enemy.setup(target_castle, enemy_stats)
	active_enemies += 1

func _on_enemy_died(_enemy: Unit) -> void:
	active_enemies = max(active_enemies - 1, 0)
	if active_enemies == 0 and current_wave > 0 and not waiting_for_next_wave and GameState.is_game_active():
		wave_completed.emit(current_wave)
		waiting_for_next_wave = true
		wave_timer = wave_break
