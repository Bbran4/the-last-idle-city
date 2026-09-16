extends Node2D

const MAX_DRAW_STRENGTH: float = 100.0
const DRAW_SPEED: float = 55.0
const MIN_LAUNCH_SPEED: float = 360.0
const MAX_LAUNCH_SPEED: float = 760.0
const IMPACT_FLASH_DURATION: float = 0.18
const SHOT_RESULT_DURATION: float = 1.5

@onready var world_view: WorldView = $WorldView
@onready var hud: HUD = $HUD

var stats: PlayerStats = PlayerStats.new()
var economy: PlayerEconomy = PlayerEconomy.new()
var draw_strength: float = 0.0
var is_drawing: bool = false
var active_arrow: Arrow = null
var impact_position: Vector2 = Vector2.ZERO
var impact_timer: float = 0.0
var aim_angle: float = 0.0
var shot_result_timer: float = 0.0

var total_score: int = 0
var shots_fired: int = 0
var successful_hits: int = 0
var bullseyes: int = 0

func _ready() -> void:
	hud.training_upgrade_pressed.connect(_on_training_upgrade_pressed)
	_refresh_hud()

func _process(delta: float) -> void:
	_update_aim()

	if is_drawing:
		draw_strength = min(draw_strength + DRAW_SPEED * delta, MAX_DRAW_STRENGTH)

	if impact_timer > 0.0:
		impact_timer = max(impact_timer - delta, 0.0)

	if shot_result_timer > 0.0:
		shot_result_timer = max(shot_result_timer - delta, 0.0)
		if shot_result_timer <= 0.0:
			hud.hide_shot_result()

	var draw_ratio: float = draw_strength / MAX_DRAW_STRENGTH
	var preview_speed: float = 0.0
	if is_drawing:
		preview_speed = stats.get_max_launch_speed(lerp(MIN_LAUNCH_SPEED, MAX_LAUNCH_SPEED, draw_ratio))
	world_view.set_draw_ratio(draw_ratio)
	world_view.set_trajectory(aim_angle, draw_ratio, preview_speed, stats.get_trajectory_prediction_quality(), is_drawing)
	world_view.update_impact(impact_position, impact_timer)
	hud.set_draw_strength(draw_ratio, is_drawing)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_R:
		_reset_session()
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and not is_drawing and active_arrow == null:
			is_drawing = true
			draw_strength = 0.0
		elif not event.pressed and is_drawing:
			_release_arrow()

func _update_aim() -> void:
	var mouse_position: Vector2 = world_view.get_world_mouse_position()
	var bow_position: Vector2 = world_view.get_bow_position()
	var aim_vector: Vector2 = mouse_position - bow_position
	if aim_vector.length_squared() > 0.001:
		aim_angle = aim_vector.angle()
	world_view.aim_bow(aim_angle)

func _release_arrow() -> void:
	is_drawing = false
	if draw_strength <= 0.0:
		draw_strength = 0.0
		return

	var strength_ratio: float = draw_strength / MAX_DRAW_STRENGTH
	var launch_speed: float = lerp(MIN_LAUNCH_SPEED, MAX_LAUNCH_SPEED, strength_ratio)
	launch_speed = stats.get_max_launch_speed(launch_speed)
	var direction: Vector2 = Vector2.RIGHT.rotated(aim_angle)

	var strength_xp: int = stats.award_strength_release_xp(strength_ratio, economy.get_xp_multiplier())
	var arrow: Arrow = world_view.fire_arrow(direction, launch_speed)
	arrow.hit_target.connect(_on_arrow_hit)
	arrow.missed.connect(_on_arrow_missed)

	active_arrow = arrow
	shots_fired += 1
	_show_result("SHOT FIRED")
	if strength_xp > 0:
		hud.show_strength_xp_gain(strength_xp)
	draw_strength = 0.0
	_refresh_hud()

func _on_arrow_hit(position: Vector2) -> void:
	if active_arrow == null:
		return

	var score_result: Dictionary = world_view.get_target().calculate_score(position)
	total_score += score_result.score
	successful_hits += 1

	var accuracy_xp: int = stats.award_accuracy_hit_xp(economy.get_xp_multiplier())
	if accuracy_xp > 0:
		hud.show_accuracy_xp_gain(accuracy_xp)

	if score_result.is_bullseye:
		bullseyes += 1

	active_arrow = null
	impact_position = position
	impact_timer = IMPACT_FLASH_DURATION
	_show_result(score_result.label)

func _on_arrow_missed() -> void:
	active_arrow = null
	_show_result("MISS")

func _on_training_upgrade_pressed() -> void:
	var cost: int = economy.get_training_manual_cost()
	if economy.buy_training_manual():
		hud.show_economy_feedback("TRAINING MANUAL %d  +%d%% XP" % [economy.training_manual_level, int((economy.get_xp_multiplier() - 1.0) * 100.0)])
	else:
		hud.show_economy_feedback("NOT ENOUGH COINS  $%d" % cost)
	_refresh_hud()

func _show_result(text: String) -> void:
	shot_result_timer = SHOT_RESULT_DURATION
	hud.show_shot_result(text)
	_refresh_hud()

func _refresh_hud() -> void:
	hud.set_score(total_score)
	hud.set_stats(shots_fired, successful_hits, bullseyes)
	hud.set_strength(stats.strength_level, stats.strength_xp, stats.strength_xp_to_next_level(), stats.strength_progress_ratio())
	hud.set_accuracy(stats.accuracy_level, stats.accuracy_xp, stats.accuracy_xp_to_next_level(), stats.accuracy_progress_ratio())
	hud.set_economy(economy.money, economy.training_manual_level, economy.get_training_manual_cost(), economy.can_buy_training_manual())

## Resets the current practice session without resetting permanent progression or money.
func _reset_session() -> void:
	is_drawing = false
	draw_strength = 0.0
	active_arrow = null
	impact_position = Vector2.ZERO
	impact_timer = 0.0
	shot_result_timer = 0.0
	total_score = 0
	shots_fired = 0
	successful_hits = 0
	bullseyes = 0
	world_view.clear_arrows()
	hud.hide_shot_result()
	_refresh_hud()
