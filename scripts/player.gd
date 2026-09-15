class_name Player
extends Unit

@export var arrow_scene: PackedScene = preload("res://scenes/arrow.tscn")
@export var arrow_spawn_offset: float = 28.0
@export var auto_fire_range: float = 1600.0

var attack_cooldown: float = 0.0

func _process(delta: float) -> void:
	attack_cooldown = maxf(attack_cooldown - delta, 0.0)
	if is_dead:
		return

	var mouse_position := get_global_mouse_position()
	look_at(mouse_position)

	if attack_cooldown <= 0.0 and global_position.distance_to(mouse_position) <= auto_fire_range:
		fire_arrow(mouse_position)

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
	arrow.setup(
		global_position + direction * arrow_spawn_offset,
		target_position,
		arrow_damage,
		stats.arrow_speed
	)
	attack_cooldown = 1.0 / maxf(stats.attack_speed, 0.01)

func get_player_stats() -> Stats:
	return stats
