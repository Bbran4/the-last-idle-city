extends Node2D

const IMPACT_FLASH_DURATION: float = 0.18
const SHOT_RESULT_DURATION: float = 1.5
const MIN_PROJECTILE_SPEED_MULTIPLIER: float = 1.0
const MAX_PROJECTILE_SPEED_MULTIPLIER: float = 10.0
const MIN_EFFECTIVE_DRAW_RATIO: float = 0.05
const QUICK_SHOT_DRAW_RATIO: float = 0.80
const QUICK_SHOT_SPREAD: float = 0.38
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
var left_mouse_held: bool = false
var full_draw_timer: float = 0.0
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
	if is_drawing and left_mouse_held:
		draw_strength = min(draw_strength + bow.draw_speed * delta, bow.max_draw_strength)

	var draw_ratio: float = draw_strength / bow.max_draw_strength
	if draw_ratio >= 1.0:
		full_draw_timer += delta
	else:
		full_draw_timer = 0.0

	if is_drawing and full_draw_timer >= FULL_DRAW_AUTO_RELEASE_TIME:
		_fire_arrow()

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
		left_mouse_held = event.pressed
		if event.pressed:
			if not is_drawing:
				_start_drawing()
		else:
			if is_drawing:
				_fire_arrow()
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		if not is_drawing:
			_start_drawing()
		if is_drawing:
			var bow: BowData = bow_inventory.get_equipped()
			draw_strength = bow.max_draw_strength * QUICK_SHOT_DRAW_RATIO
			_fire_arrow(true)
		return

func _toggle_equipment() -> void:
	if not _is_near_tent():
		return
	equipment_open = not equipment_open
	hud.set_equipment_visible(equipment_open)

func _is_near_tent() -> bool:
	var tent: Node2D = world_view.get_node("CustomizationTent") as Node2D
	return world_view.player.position.distance_to(tent.position) <= TENT_INTERACTION_RADIUS

func _start_drawing() -> void:
	if is_drawing:
		return
	is_drawing = true
	draw_strength = 0.0
	full_draw_timer = 0.0

func _update_aim() -> void:
	var mouse_world_position: Vector2 = world_view.get_world_mouse_position()
	world_view.player.set_facing_from_mouse(mouse_world_position)
	var aim_vector: Vector2 = mouse_world_position - world_view.get_bow_position()
	if aim_vector.length_squared() > 0.001:
		aim_angle = aim_vector.angle() + world_view.player.get_aim_wobble()
		if draw_strength > 0.0:
			var bow: BowData = bow_inventory.get_equipped()
			var draw_ratio: float = draw_strength / bow.max_draw_strength
			if draw_ratio >= 1.0:
				var wobble_progress: float = clamp((full_draw_timer - FULL_DRAW_WOBBLE_DELAY) / max(FULL_DRAW_AUTO_RELEASE_TIME - FULL_DRAW_WOBBLE_DELAY, 0.001), 0.0, 1.0)
				var wobble: float = sin(full_draw_timer * FULL_DRAW_WOBBLE_SPEED) * FULL_DRAW_WOBBLE_MAX_ANGLE * wobble_progress
				aim_angle += wobble
	world_view.aim_bow(world_view.player.get_bow_aim_angle(aim_angle))

func _fire_arrow(is_quick_shot: bool = false) -> void:
	if not is_drawing:
		return

	is_drawing = false
	left_mouse_held = false
	full_draw_timer = 0.0
	if draw_strength <= 0.0:
		draw_strength = 0.0
		return
	var bow: BowData = bow_inventory.get_equipped()
	var strength_ratio: float = draw_strength / bow.max_draw_strength
	var shot_angle: float = aim_angle
	if is_quick_shot:
		strength_ratio = QUICK_SHOT_DRAW_RATIO
		shot_angle += randf_range(-QUICK_SHOT_SPREAD, QUICK_SHOT_SPREAD)
	var launch_speed: float = lerp(bow.min_launch_speed, bow.max_launch_speed, strength_ratio)
	launch_speed = stats.get_max_launch_speed(launch_speed) * _get_projectile_speed_multiplier(strength_ratio)
	var strength_xp: int = stats.award_strength_release_xp(strength_ratio, economy.get_xp_multiplier())
	var arrow: Arrow = world_view.fire_arrow(Vector2.RIGHT.rotated(shot_angle), launch_speed)
	arrow.hit_target.connect(_on_arrow_hit)
	arrow.missed.connect(_on_arrow_missed)
	shots_fired += 1
	_show_result("QUICK SHOT" if is_quick_shot else "SHOT FIRED")
	if strength_xp > 0:
		hud.show_strength_xp_gain(strength_xp)
	draw_strength = 0.0
	_refresh_hud()

func _on_arrow_hit(position: Vector2, target: Target, arrow: Arrow) -> void:
	var coin_reward: int = target.get_coin_reward()
	economy.add_money(coin_reward)
	total_coins_earned += coin_reward
	successful_hits += 1
	if target.is_bullseye_hit(position):
		bullseyes += 1
	var shot_distance: float = arrow.get_shot_distance_to_target(target)
	var accuracy_xp: int = stats.award_accuracy_hit_xp(shot_distance, economy.get_xp_multiplier())
	if accuracy_xp > 0:
		hud.show_accuracy_xp_gain(accuracy_xp)
	impact_position = position
	impact_timer = IMPACT_FLASH_DURATION
	_show_result(target.get_reward_label())

func _on_arrow_missed() -> void:
	_show_result("MISS")

func _on_training_upgrade_pressed() -> void:
	var cost: int = economy.get_training_manual_cost()
	if economy.buy_training_manual():
		hud.show_economy_feedback("TRAINING MANUAL %d  +%d%% XP" % [economy.training_manual_level, int((economy.get_xp_multiplier() - 1.0) * 100.0)])
	else:
		hud.show_economy_feedback("NOT ENOUGH COINS  $%d" % cost)
	_refresh_hud()

func _on_bow_action_requested(bow_id: String) -> void:
	var bow: BowData = bow_inventory.get_bow(bow_id)
	if bow == null:
		return

	if bow_inventory.is_owned(bow_id):
		if bow_inventory.equip(bow_id, stats.strength_level):
			world_view.configure_bow(bow)
			hud.show_economy_feedback("EQUIPPED  %s" % bow.display_name)
		else:
			hud.show_economy_feedback("REQUIRES STRENGTH %d" % bow.required_strength)
		_refresh_hud()
		return

	if stats.strength_level < bow.required_strength:
		hud.show_economy_feedback("REQUIRES STRENGTH %d" % bow.required_strength)
		return

	if economy.money < bow.price:
		hud.show_economy_feedback("NOT ENOUGH COINS  $%d" % bow.price)
		return

	if not bow_inventory.can_purchase(bow_id, economy.money, stats.strength_level):
		hud.show_economy_feedback("PURCHASE UNAVAILABLE")
		return

	if not economy.spend_money(bow.price):
		hud.show_economy_feedback("NOT ENOUGH COINS  $%d" % bow.price)
		return

	if not bow_inventory.unlock(bow_id):
		economy.add_money(bow.price)
		hud.show_economy_feedback("PURCHASE FAILED")
		_refresh_hud()
		return

	if not bow_inventory.equip(bow_id, stats.strength_level):
		economy.add_money(bow.price)
		hud.show_economy_feedback("EQUIP FAILED")
		_refresh_hud()
		return

	world_view.configure_bow(bow)
	hud.show_economy_feedback("PURCHASED AND EQUIPPED  %s" % bow.display_name)
	_refresh_hud()

func _on_range_upgrade_requested() -> void:
	if range_level >= MAX_RANGE_LEVEL:
		return
	var next_level: int = range_level + 1
	var cost: int = RANGE_LEVEL_COSTS[next_level - 1]
	if not economy.spend_money(cost):
		hud.show_economy_feedback("NOT ENOUGH COINS  $%d" % cost)
		return
	range_level = next_level
	RangeSave.save_range_level(range_level)
	world_view.set_active_targets(range_level)
	hud.show_economy_feedback("RANGE LEVEL %d  NEW TARGET UNLOCKED" % range_level)
	_refresh_hud()

func _show_result(text: String) -> void:
	shot_result_timer = SHOT_RESULT_DURATION
	hud.show_shot_result(text)
	_refresh_hud()

func _on_stat_levelled_up(stat_name: String, new_level: int) -> void:
	hud.show_stat_level_up(stat_name, new_level)
	shot_result_timer = SHOT_RESULT_DURATION
	_refresh_hud()

func _refresh_hud() -> void:
	hud.set_coins_earned(total_coins_earned)
	hud.set_stats(shots_fired, successful_hits, bullseyes)
	hud.set_strength(stats.strength_level, stats.strength_xp, stats.strength_xp_to_next_level(), stats.strength_progress_ratio())
	hud.set_accuracy(stats.accuracy_level, stats.accuracy_xp, stats.accuracy_xp_to_next_level(), stats.accuracy_progress_ratio())
	hud.set_economy(economy.money, economy.training_manual_level, economy.get_training_manual_cost(), economy.can_buy_training_manual())
	hud.set_bows(bow_inventory.get_all_bows(), bow_inventory.owned, bow_inventory.equipped_bow_id, economy.money, stats.strength_level)
	hud.set_range_level(range_level, MAX_RANGE_LEVEL, RANGE_LEVEL_COSTS, economy.money)

func _reset_session() -> void:
	is_drawing = false
	left_mouse_held = false
	draw_strength = 0.0
	full_draw_timer = 0.0
	impact_position = Vector2.ZERO
	impact_timer = 0.0
	shot_result_timer = 0.0
	equipment_open = false
	hud.set_equipment_visible(false)
	total_coins_earned = 0
	shots_fired = 0
	successful_hits = 0
	bullseyes = 0
	world_view.clear_arrows()
	hud.hide_shot_result()
	_refresh_hud()
