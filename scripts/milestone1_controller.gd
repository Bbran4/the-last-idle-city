extends Node2D

@export var enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")
@export var enemy_count: int = 1

@onready var player: Player = $Player
@onready var castle: Castle = $Castle

func _ready() -> void:
	GameState.start_game()
	_spawn_test_enemy()
	castle.health_changed.connect(_on_castle_health_changed)
	_on_castle_health_changed(castle.health, castle.max_health)

func _spawn_test_enemy() -> void:
	var enemy := enemy_scene.instantiate() as Enemy
	if enemy == null:
		return
	add_child(enemy)
	enemy.global_position = Vector2(1500.0, 540.0)
	var enemy_stats := Stats.new()
	enemy_stats.max_health = 30.0
	enemy_stats.health = 30.0
	enemy.setup(castle, enemy_stats)

func _on_castle_health_changed(current: float, maximum: float) -> void:
	var ui := $UI as GameUI
	if ui:
		ui.set_castle_health(current, maximum)
