class_name Player
extends Unit

@export var arrow_scene: PackedScene = preload("res://scenes/arrow.tscn")
@export var arrow_spawn_offset: float = 28.0

@onready var castle: Castle = get_node_or_null("../Castle") as Castle
@onready var wave_manager: WaveManager = get_node_or_null("../WaveManager") as WaveManager

var attack_cooldown: float = 0.0

func _process(delta: float) -> void:
	attack_cooldown = maxf(attack_cooldown - delta, 0.0)
	if is_dead or wave_manager == null or wave_manager.is_intermission():
		return

	var mouse_position := get_global_mouse_position()
	look_at(mouse_position)

	var target := _get_target_in_range(mouse_position)
	if attack_cooldown <= 0.0 and target != null:
		fire_arrow(target.global_position)

func _get_target_in_range(mouse_position: Vector2) -> Enemy:
	var attack_range := get_attack_range()
	var best_target: Enemy = null
	var best_mouse_distance := INF

	for node in get_tree().get_nodes_in_group("enemies"):
		var enemy := node as Enemy
		if enemy == null or enemy.is_dead:
			continue

		var distance_to_enemy := global_position.distance_to(enemy.global_position)
		if distance_to_enemy > attack_range:
			continue

		var mouse_distance := mouse_position.distance_to(enemy.global_position)
		if mouse_distance < best_mouse_distance:
			best_mouse_distance = mouse_distance
			best_target = enemy

	return best_target

func fire_arrow(target_position: Vector2) -> void:
	if arrow_scene == null or stats == null:
		return

	var arrow := arrow_scene.instantiate() as Arrow
	if arrow == null:
		return

	get_tree().current_scene.add_child(arrow)
	var direction := global_position.direction_to(target_position)
	var arrow_damage := stats.damage
	if randf() < stats.critical_chance:
		arrow_damage *= stats.critical_damage
	var ground_y: float = castle.get_ground_y() if castle else global_position.y + 300.0
	arrow.setup(
		global_position + direction * arrow_spawn_offset,
		target_position,
		arrow_damage,
		stats.arrow_speed,
		ground_y
	)
	attack_cooldown = 1.0 / maxf(stats.attack_speed, 0.01)

func get_attack_range() -> float:
	if stats == null:
		return 0.0
	return maxf(stats.range, 0.0)

func get_player_stats() -> Stats:
	return stats
