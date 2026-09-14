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
	GameState.data.grow_population(delta)
	GameState.data.generate_souls(delta)
	GameState.data.process_energy(delta)
	GameState.data.process_chain_automation(delta)
	GameState.data.process_unit_automation(delta)
	GameState.data.produce_materials(GameState.data.scrap_yard_production_per_second().multiply_float(delta))

	tick.emit(delta)
