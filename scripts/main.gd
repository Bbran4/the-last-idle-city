extends Node2D

const IMPACT_FLASH_DURATION: float = 0.18
const SHOT_RESULT_DURATION: float = 1.5
const SHOT_RECOVERY_TIME: float = 1.0
const MIN_PROJECTILE_SPEED_MULTIPLIER: float = 1.0
const MAX_PROJECTILE_SPEED_MULTIPLIER: float = 10.0
const MIN_EFFECTIVE_DRAW_RATIO: float = 0.05
const RIGHT_MOUSE_DRAW_DECAY: float = 0.225
const FULL_DRAW_WOBBLE_DELAY: float = 0.35
const FULL_DRAW_AUTO_RELEASE_TIME: float = 2.0
const FULL_DRAW_WOBBLE_MAX_ANGLE: float = 0.14
const FULL_DRAW_WOBBLE_SPEED: float = 18.0
const RANGE_LEVEL_COSTS: Array[int] = [0, 75, 175, 350]
const MAX_RANGE_LEVEL: int = 4
const CROUCH_TRAJECTORY_BOOST: float = 0.20
const TENT_INTERACTION_RADIUS: float = 300.0

@onready var world_view: WorldView = $WorldView
@onready var hud: HUD = $HUD

var stats: PlayerStats = PlayerStats.new()
var economy: PlayerEconomy = PlayerEconomy.new()
var bow_inventory: BowInventory = BowInventory.new()
var draw_strength: float = 0.0
var is_drawing: bool = false
var right_mouse_held: bool = false
var full_draw_timer: float = 0.0
var shot_recovery_timer: float = 0.0
var impact_position: Vector2 = Vector2.ZERO
var impact_timer: float = 0.0
var aim_angle: float = 0.0
var shot_result_timer: float = 0.0
var range_level: int = 1
var equipment_open: bool = false

var total_coins_earned: int = 0
var shots_fired: int = 0
var successful_hits: int = 0
var bullseyes: int = 0

func _ready() -> void:
	range_level = RangeSave.load_range_level(range_level, MAX_RANGE_LEVEL)
	world_view.configure_bow(bow_inventory.get_equipped())
	hud.training_upgrade_pressed.connect(_on_training_upgrade_pressed)
	hud.bow_action_requested.connect(_on_bow_action_requested)
	hud.range_upgrade_requested.connect(_on_range_upgrade_requested)
	stats.stat_levelled_up.connect(_on_stat_levelled_up)
	hud.set_equipment_visible(false)
	world_view.set_active_targets(range_level)
	_refresh_hud()

func _process(delta: float) -> void:
	_update_aim()
	var bow: BowData = bow_inventory.get_equipped()
	shot_recovery_timer = max(shot_recovery_timer - delta, 0.0)
	world_view.set_recovery_progress(shot_recovery_timer / SHOT_RECOVERY_TIME)

	if is_drawing:
		if right_mouse_held:
			draw_strength = min(draw_strength + bow.draw_speed * delta, bow.max_draw_strength)
		else:
			draw_strength = max(draw_strength - bow.max_draw_strength * RIGHT_MOUSE_DRAW_DECAY * delta, 0.0)

	var draw_ratio: float = draw_strength / bow.max_draw_strength
	if draw_ratio >= 1.0:
		full_draw_timer += delta
	else:
		full_draw_timer = 0.0

	if is_drawing and full_draw_timer >= FULL_DRAW_AUTO_RELEASE_TIME:
		_fire_arrow()

	if not is_drawing and shot_recovery_timer <= 0.0 and right_mouse_held:
		_start_drawing()
		bow = bow_inventory.get_equipped()
		draw_ratio = draw_strength / bow.max_draw_strength

	if impact_timer > 0.0:
		impact_timer = max(impact_timer - delta, 0.0)
	if shot_result_timer > 0.0:
		shot_result_timer = max(shot_result_timer - delta, 0.0)
		if shot_result_timer <= 0.0:
			hud.hide_shot_result()

	var projectile_speed_multiplier: float = _get_projectile_speed_multiplier(draw_ratio)
	var preview_speed: float = 0.0
	if is_drawing:
		preview_speed = stats.get_max_launch_speed(lerp(bow.min_launch_speed, bow.max_launch_speed, draw_ratio)) * projectile_speed_multiplier
	world_view.set_draw_ratio(draw_ratio)
	var trajectory_quality: float = stats.get_trajectory_prediction_quality()
	if world_view.player.is_crouched():
		trajectory_quality = clamp(trajectory_quality + CROUCH_TRAJECTORY_BOOST, 0.0, 1.0)
	var trajectory_visible: bool = is_drawing and not world_view.player.is_airborne()
	world_view.set_trajectory(aim_angle, draw_ratio, preview_speed, trajectory_quality, trajectory_visible)
	world_view.update_impact(impact_position, impact_timer)
	hud.set_draw_strength(draw_ratio, is_drawing)
	var near_tent: bool = _is_near_tent()
	if not near_tent and equipment_open:
		equipment_open = false
		hud.set_equipment_visible(false)
	hud.set_tent_prompt(near_tent, equipment_open)

func _get_projectile_speed_multiplier(draw_ratio: float) -> float:
	var normalized_draw: float = clamp((draw_ratio - MIN_EFFECTIVE_DRAW_RATIO) / (1.0 - MIN_EFFECTIVE_DRAW_RATIO), 0.0, 1.0)
	return lerp(MIN_PROJECTILE_SPEED_MULTIPLIER, MAX_PROJECTILE_SPEED_MULTIPLIER, normalized_draw)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_R:
		_reset_session()
		return

	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_E:
		_toggle_equipment()
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_fire_arrow()
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		right_mouse_held = event.pressed
		if event.pressed and not is_drawing and shot_recovery_timer <= 0.0:
			_start_drawing()

func _toggle_equipment() -> void:
	if not _is_near_tent():
		return
	equipment_open = not equipment_open
	hud.set_equipment_visible(equipment_open)

func _on_stat_levelled_up(stat_name: String, new_level: int) -> void:
	hud.show_stat_level_up(stat_name, new_level)
	shot_result_timer = SHOT_RESULT_DURATION
	_refresh_hud()
