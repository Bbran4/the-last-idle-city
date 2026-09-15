class_name Player
extends Unit

@export var arrow_scene: PackedScene = preload("res://scenes/arrow.tscn")
@export var arrow_spawn_offset: float = 28.0
@export var auto_fire_range: float = 1400.0

var attack_cooldown: float = 0.0

func _process(delta: float) -> void:
	attack_cooldown = maxf(attack_cooldown - delta, 0.0)
	if is_dead:
		return

	var target := _find_nearest_enemy()
	if target == null:
		return

	look_at(target.global_position)

	if attack_cooldown <= 0.0:
		fire_arrow(target.global_position)

func _find_nearest_enemy() -> Enemy:
	var nearest: Enemy = null
	var nearest_distance := auto_fire_range

	for node in get_tree().get_nodes_in_group("enemies"):
		if not node is Enemy:
			continue
		var enemy := node as Enemy
		if enemy.is_dead:
			continue
		var distance := global_position.distance_to(enemy.global_position)
		if distance <= nearest_distance:
			nearest = enemy
			nearest_distance = distance

	return nearest

func fire_arrow(target_position: Vector2) -> void:
	if arrow_scene == null or stats == null:
		return

	var arrow := arrow_scene.instantiate() as Arrow
	if arrow == null:
		return

	get_tree().current_scene.add_child(arrow)
	var direction := global_position.direction_to(target_position)
	arrow.setup(
		global_position + direction * arrow_spawn_offset,
		target_position,
		stats.damage,
		stats.arrow_speed
	)
	attack_cooldown = 1.0 / maxf(stats.attack_speed, 0.01)

func get_player_stats() -> Stats:
	return stats
