class_name GameState
extends Node

signal wave_changed(wave: int)
signal game_started
signal game_over

var current_wave: int = 0
var running: bool = false
var defeated: bool = false

func start_game() -> void:
	current_wave = 0
	running = true
	defeated = false
	game_started.emit()

func set_wave(wave: int) -> void:
	current_wave = max(wave, 0)
	wave_changed.emit(current_wave)

func advance_wave() -> void:
	set_wave(current_wave + 1)

func end_game() -> void:
	if defeated:
		return
	running = false
	defeated = true
	game_over.emit()

func is_game_active() -> bool:
	return running and not defeated
