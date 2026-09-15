class_name WaveManager
extends Node

signal wave_started(wave: int)
signal wave_completed(wave: int)

@export var starting_wave: int = 1
@export var enemies_per_wave: int = 5
@export var enemy_count_growth: int = 1

var current_wave: int = 0
var active_enemies: int = 0

func start_next_wave() -> void:
	current_wave = max(current_wave + 1, starting_wave)
	active_enemies = enemies_for_wave(current_wave)
	wave_started.emit(current_wave)
	if GameState.is_game_active():
		GameState.set_wave(current_wave)

func enemies_for_wave(wave: int) -> int:
	return max(enemies_per_wave + ((wave - 1) * enemy_count_growth), 1)

func register_enemy() -> void:
	active_enemies += 1

func register_enemy_defeated() -> void:
	active_enemies = max(active_enemies - 1, 0)
	if active_enemies == 0 and current_wave > 0:
		wave_completed.emit(current_wave)
