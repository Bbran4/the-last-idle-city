class_name GameClock
extends Node

signal tick(delta: float)

@export var tick_interval: float = 1.0

var accumulator: float = 0.0
var running: bool = true


func _process(delta: float) -> void:
	if not running:
		return

	accumulator += delta

	while accumulator >= tick_interval:
		accumulator -= tick_interval
		_process_tick(tick_interval)


func _process_tick(delta: float) -> void:
	GameState.data.game_time += delta
	GameState.data.total_ticks += 1
	GameState.data.gold += 1.0
	
	tick.emit(delta)
