extends Node2D

@export var enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")
@export var enemy_count: int = 2
@export var spawn_distance: float = 900.0

@onready var player: Player = $Player
@onready var castle: Castle = $Castle

func _ready() -> void:
	GameState.start_game()
	_spawn_test_enemies()
	castle.health_changed.connect(_on_castle_health_changed)
	_on_castle_health_changed(castle.health, castle.max_health)

func _spawn_test_enemies() -> void:
	for i in enemy_count:
		var enemy := enemy_scene.instantiate() as Enemy
		if enemy == null:
			continue
		add_child(enemy)
		enemy.add_to_group("enemies")
		var side := -1.0 if i % 2 == 0 else 1.0
		enemy.global_position = castle.global_position + Vector2(side * spawn_distance, -80.0 + i * 160.0)
		var enemy_stats := Stats.new()
		enemy_stats.max_health = 30.0
		enemy_stats.health = 30.0
		enemy.setup(castle, enemy_stats)

func _on_castle_health_changed(current: float, maximum: float) -> void:
	var ui := $UI as GameUI
	if ui:
		ui.set_castle_health(current, maximum)
