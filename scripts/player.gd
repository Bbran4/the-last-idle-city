class_name Player
extends Unit

@export var arrow_scene: PackedScene = preload("res://scenes/arrow.tscn")
@export var arrow_spawn_offset: float = 28.0
@export var aim_variance_degrees: float = 2.5

@onready var castle: Castle = get_node_or_null("../Castle") as Castle
@onready var wave_manager: WaveManager = get_node_or_null("../WaveManager") as WaveManager
@onready var skill_manager: SkillManager = get_node_or_null("../SkillManager") as SkillManager

var attack_cooldown: float = 0.0

func _ready() -> void:
	super._ready()
	if skill_manager:
		skill_manager.power_shot_requested.connect(_on_power_shot_requested)

func _process(delta: float) -> void:
	attack_cooldown = maxf(attack_cooldown - delta, 0.0)
	if is_dead or wave_manager == null or wave_manager.is_intermission():
		return

	var mouse_position := get_global_mouse_position()
	look_at(mouse_position)

	if attack_cooldown <= 0.0:
		fire_arrow(_get_accurate_target_position(mouse_position))

func _get_accurate_target_position(mouse_position: Vector2) -> Vector2:
	var clamped_target := _get_clamped_target_position(mouse_position)
	var offset := clamped_target - global_position
	if offset.length_squared() <= 0.0:
		return clamped_target

	var variance := deg_to_rad(randf_range(-aim_variance_degrees, aim_variance_degrees))
	var varied_direction := offset.normalized().rotated(variance)
	return global_position + varied_direction * offset.length()

func _get_clamped_target_position(mouse_position: Vector2) -> Vector2:
	var offset := mouse_position - global_position
	var attack_range := get_attack_range()

	if offset.length() <= attack_range:
		return mouse_position
	if offset.length_squared() <= 0.0:
		return global_position + Vector2.RIGHT * attack_range

	return global_position + offset.normalized() * attack_range

func fire_arrow(target_position: Vector2) -> void:
	if arrow_scene == null or stats == null:
		return

	var arrow := arrow_scene.instantiate() as Arrow
	if arrow == null:
		return

	get_tree().current_scene.add_child(arrow)
	var direction := global_position.direction_to(target_position)
	var arrow_damage := stats.damage
	if skill_manager and skill_manager.consume_power_shot():
		arrow_damage *= SkillManager.POWER_SHOT_DAMAGE_MULTIPLIER
	elif randf() < stats.critical_chance:
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

func _on_power_shot_requested() -> void:
	if wave_manager == null or wave_manager.is_intermission():
		return

func get_attack_range() -> float:
	if stats == null:
		return 0.0
	return maxf(stats.range, 0.0)

func get_player_stats() -> Stats:
	return stats
