extends Node2D

const IMPACT_FLASH_DURATION: float = 0.18
const SHOT_RESULT_DURATION: float = 1.5
const MIN_PROJECTILE_SPEED_MULTIPLIER: float = 1.0
const MAX_PROJECTILE_SPEED_MULTIPLIER: float = 10.0
const MIN_EFFECTIVE_DRAW_RATIO: float = 0.05
const QUICK_SHOT_DRAW_RATIO: float = 0.80
const QUICK_SHOT_SPREAD: float = 0.38
const SHOT_COOLDOWN: float = 1.0
const FAST_DRAW_RATIO: float = 0.80
const FAST_DRAW_SPEED_MULTIPLIER: float = 4.0
const FINAL_DRAW_SPEED_MULTIPLIER: float = 1.30
const SLOW_DRAW_SPEED_MULTIPLIER: float = 0.80
const FULL_DRAW_WOBBLE_DELAY: float = 0.35
const FULL_DRAW_AUTO_RELEASE_TIME: float = 2.0
const FULL_DRAW_WOBBLE_MAX_ANGLE: float = 0.14
const FULL_DRAW_WOBBLE_SPEED: float = 18.0
const RANGE_LEVEL_COSTS: Array[int] = [0, 75, 175, 350]
const MAX_RANGE_LEVEL: int = 4
const CROUCH_TRAJECTORY_BOOST: float = 0.20
const TENT_INTERACTION_RADIUS: float = 300.0
const HIT_STOP_DURATION: float = 0.05
const BULLSEYE_HIT_STOP_DURATION: float = 0.09
const HIT_SHAKE_STRENGTH: float = 4.0
const BULLSEYE_SHAKE_STRENGTH: float = 9.0
const SHAKE_DURATION: float = 0.18

@onready var world_view: WorldView = $WorldView
@onready var hud: HUD = $HUD

var total_coins_earned: int = 0
var shots_fired: int = 0
var successful_hits: int = 0
var bullseyes: int = 0

func _ready() -> void:
	player.shot_requested.connect(_on_player_shot)
	Stats.stat_levelled_up.connect(_on_stat_levelled_up)
	hud.training_upgrade_pressed.connect(_on_training_upgrade_pressed)
	hud.bow_action_requested.connect(_on_bow_action_requested)
	hud.range_upgrade_requested.connect(_on_range_upgrade_requested)
	hud.set_equipment_visible(false)
	world_view.set_active_targets(range_level)
	_refresh_hud()

func _process(delta: float) -> void:
	impact_timer = max(impact_timer - delta, 0.0)
	var draw_ratio := player.get_draw_ratio()
	var bow := player.get_equipped_bow()
	var preview_speed := 0.0 if bow == null else Stats.get_max_launch_speed(lerp(bow.min_launch_speed, bow.max_launch_speed, draw_ratio))
	var quality := Skills.get_trajectory_prediction_quality()
	if player.is_crouched(): quality = clamp(quality + CROUCH_TRAJECTORY_BOOST, 0.0, 1.0)
	world_view.set_trajectory(player.get_aim_angle(), draw_ratio, preview_speed, quality, draw_ratio > 0.0 and not player.is_airborne())
	hud.set_draw_strength(draw_ratio, draw_ratio > 0.0)
	hud.set_reload_progress(player.get_reload_progress(), player.get_global_transform_with_canvas().origin)
	world_view.update_impact(impact_position, impact_timer)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE: get_tree().change_scene_to_file("res://scenes/hub.tscn")
		elif event.keycode == KEY_R: _reset_session()
		elif event.keycode == KEY_E: _toggle_equipment()

func _toggle_equipment() -> void:
	if not _is_near_tent(): return
	equipment_open = not equipment_open
	hud.set_equipment_visible(equipment_open)
	player.set_input_enabled(not equipment_open)

func _is_near_tent() -> bool:
	var tent := world_view.get_node_or_null("CustomizationTent") as Node2D
	return tent != null and player.position.distance_to(tent.position) <= 300.0

func _on_player_shot(direction: Vector2, launch_speed: float, is_quick_shot: bool) -> void:
	var arrow := world_view.fire_arrow(direction, launch_speed)
	arrow.set_meta("is_quick_shot", is_quick_shot)
	arrow.hit_target.connect(_on_arrow_hit)
	arrow.missed.connect(_on_arrow_missed)
	shots_fired += 1
	_refresh_hud()

func _on_arrow_hit(position: Vector2, target: Target, arrow: Arrow) -> void:
	var coin_reward: int = target.get_coin_reward()
	Economy.add_money(coin_reward)
	total_coins_earned += coin_reward
	successful_hits += 1
	var is_bullseye: bool = target.is_bullseye_hit(position)
	if is_bullseye:
		bullseyes += 1
	var shot_distance: float = arrow.get_shot_distance_to_target(target)
	var accuracy_xp: int = 0
	if not bool(arrow.get_meta("is_quick_shot", false)):
		accuracy_xp = Stats.award_accuracy_hit_xp(shot_distance, Economy.get_xp_multiplier())
	if accuracy_xp > 0:
		hud.show_accuracy_xp_gain(accuracy_xp)
	impact_position = position
	impact_timer = IMPACT_FLASH_DURATION
	world_view.trigger_shake(BULLSEYE_SHAKE_STRENGTH if is_bullseye else HIT_SHAKE_STRENGTH, SHAKE_DURATION)
	_trigger_hit_stop(BULLSEYE_HIT_STOP_DURATION if is_bullseye else HIT_STOP_DURATION)
	_show_result(target.get_reward_label())

func _trigger_hit_stop(duration: float) -> void:
	Engine.time_scale = 0.05
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1.0

func _on_arrow_missed() -> void:
	_show_result("MISS")

func _on_training_upgrade_pressed() -> void:
	if Skills.buy_training_manual():
		hud.show_economy_feedback("TRAINING MANUAL %d" % Skills.training_manual_level)
	_refresh_hud()

func _on_bow_action_requested(bow_id: String) -> void:
	var bow := player.player.bow_inventory.get_bow(bow_id)
	if bow == null: return
	if player.player.bow_inventory.is_owned(bow_id):
		player.equip_bow(bow_id)
		_refresh_hud()
		return
	if Stats.strength_level < bow.required_strength or Economy.money < bow.price: return
	if Economy.spend_money(bow.price) and player.player.bow_inventory.unlock(bow_id) and player.equip_bow(bow_id):
		_refresh_hud()

func _on_range_upgrade_requested() -> void:
	if range_level >= MAX_RANGE_LEVEL:
		return
	var next_level: int = range_level + 1
	var cost: int = RANGE_LEVEL_COSTS[next_level - 1]
	if not Economy.spend_money(cost):
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
	hud.set_strength(Stats.strength_level, Stats.strength_xp, Stats.strength_xp_to_next_level(), Stats.strength_progress_ratio())
	hud.set_accuracy(Stats.accuracy_level, Stats.accuracy_xp, Stats.accuracy_xp_to_next_level(), Stats.accuracy_progress_ratio())
	hud.set_economy(Economy.money, Economy.training_manual_level, Economy.get_training_manual_cost(), Economy.can_buy_training_manual())
	hud.set_bows(player.bow_inventory.get_all_bows(), player.bow_inventory.owned, player.bow_inventory.equipped_bow_id, Economy.money, Stats.strength_level)
	hud.set_range_level(range_level, MAX_RANGE_LEVEL, RANGE_LEVEL_COSTS, Economy.money)

func _reset_session() -> void:
	is_drawing = false
	left_mouse_held = false
	slow_draw_held = false
	draw_strength = 0.0
	full_draw_timer = 0.0
	impact_position = Vector2.ZERO
	impact_timer = 0.0
	shot_result_timer = 0.0
	shot_cooldown_timer = 0.0
	equipment_open = false
	hud.set_equipment_visible(false)
	total_coins_earned = 0
	shots_fired = 0
	successful_hits = 0
	bullseyes = 0
	world_view.clear_arrows()
	hud.hide_shot_result()
	_refresh_hud()
