extends Node2D

const IMPACT_FLASH_DURATION: float = 0.18
const SHOT_RESULT_DURATION: float = 1.5
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
@onready var player: Player = $WorldView/Player
@onready var hud: HUD = $HUD

var impact_position: Vector2 = Vector2.ZERO
var impact_timer: float = 0.0
var shot_result_timer: float = 0.0
var range_level: int = 1
var equipment_open: bool = false
var total_coins_earned: int = 0
var shots_fired: int = 0
var successful_hits: int = 0
var bullseyes: int = 0

func _ready() -> void:
	range_level = SaveManager.load_range_level(range_level, MAX_RANGE_LEVEL)
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
	if shot_result_timer > 0.0:
		shot_result_timer = max(shot_result_timer - delta, 0.0)
		if shot_result_timer <= 0.0:
			hud.hide_shot_result()
	var draw_ratio: float = player.get_draw_ratio()
	var preview_speed: float = player.get_launch_speed_for_draw_ratio(draw_ratio)
	var quality: float = Skills.get_trajectory_prediction_quality()
	if player.is_crouched():
		quality = clamp(quality + CROUCH_TRAJECTORY_BOOST, 0.0, 1.0)
	world_view.set_trajectory(player.get_aim_direction(), draw_ratio, preview_speed, quality, draw_ratio > 0.0 and not player.is_airborne())
	world_view.update_impact(impact_position, impact_timer)
	hud.set_draw_strength(draw_ratio, draw_ratio > 0.0)
	hud.set_reload_progress(player.get_reload_progress(), player.get_global_transform_with_canvas().origin)
	var near_tent: bool = _is_near_tent()
	if not near_tent and equipment_open:
		equipment_open = false
		hud.set_equipment_visible(false)
		player.set_input_enabled(true)
	hud.set_tent_prompt(near_tent, equipment_open)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_ESCAPE:
				get_tree().change_scene_to_file("res://scenes/hub.tscn")
			KEY_R:
				_reset_session()
			KEY_E:
				_toggle_equipment()

func _toggle_equipment() -> void:
	if not _is_near_tent():
		return
	equipment_open = not equipment_open
	hud.set_equipment_visible(equipment_open)
	player.set_input_enabled(not equipment_open)

func _is_near_tent() -> bool:
	var tent: Node2D = world_view.get_node_or_null("CustomizationTent") as Node2D
	return tent != null and player.position.distance_to(tent.position) <= TENT_INTERACTION_RADIUS

func _on_player_shot(direction: Vector2, launch_speed: float, is_quick_shot: bool) -> void:
	var arrow: Arrow = world_view.fire_arrow(direction, launch_speed)
	arrow.set_meta("is_quick_shot", is_quick_shot)
	arrow.hit_target.connect(_on_arrow_hit)
	arrow.missed.connect(_on_arrow_missed)
	shots_fired += 1
	_show_result("QUICK SHOT" if is_quick_shot else "SHOT FIRED")

func _on_arrow_hit(position: Vector2, target: Target, arrow: Arrow) -> void:
	var coin_reward: int = target.get_coin_reward()
	Economy.add_money(coin_reward)
	total_coins_earned += coin_reward
	successful_hits += 1
	var is_bullseye: bool = target.is_bullseye_hit(position)
	if is_bullseye:
		bullseyes += 1
	if not bool(arrow.get_meta("is_quick_shot", false)):
		Stats.award_accuracy_hit_xp(arrow.get_shot_distance_to_target(target), Skills.get_xp_multiplier())
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
	var cost: int = Skills.get_training_manual_cost()
	if Skills.buy_training_manual():
		hud.show_economy_feedback("TRAINING MANUAL %d  +%d%% XP" % [Skills.training_manual_level, int((Skills.get_xp_multiplier() - 1.0) * 100.0)])
	else:
		hud.show_economy_feedback("NOT ENOUGH COINS  $%d" % cost)
	_refresh_hud()

func _on_bow_action_requested(bow_id: String) -> void:
	var bow: BowData = player.bow_inventory.get_bow(bow_id)
	if bow == null:
		return
	if player.bow_inventory.is_owned(bow_id):
		if player.equip_bow(bow_id):
			hud.show_economy_feedback("EQUIPPED  %s" % bow.display_name)
		_refresh_hud()
		return
	if Stats.strength_level < bow.required_strength or Economy.money < bow.price:
		hud.show_economy_feedback("PURCHASE UNAVAILABLE")
		return
	if not Economy.spend_money(bow.price):
		return
	if not player.bow_inventory.unlock(bow_id) or not player.equip_bow(bow_id):
		Economy.add_money(bow.price)
		hud.show_economy_feedback("PURCHASE FAILED")
		_refresh_hud()
		return
	hud.show_economy_feedback("PURCHASED AND EQUIPPED  %s" % bow.display_name)
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
	SaveManager.save_range_level(range_level)
	world_view.set_active_targets(range_level)
	hud.show_economy_feedback("RANGE LEVEL %d  NEW TARGET UNLOCKED" % range_level)
	_refresh_hud()

func _show_result(text: String) -> void:
	shot_result_timer = SHOT_RESULT_DURATION
	hud.show_shot_result(text)
	_refresh_hud()

func _on_stat_levelled_up(stat_name: String, new_level: int) -> void:
	hud.show_stat_level_up(stat_name, new_level)
	_show_result("STAT LEVEL UP")

func _refresh_hud() -> void:
	hud.set_coins_earned(total_coins_earned)
	hud.set_stats(shots_fired, successful_hits, bullseyes)
	hud.set_strength(Stats.strength_level, Stats.strength_xp, Stats.strength_xp_to_next_level(), Stats.strength_progress_ratio())
	hud.set_accuracy(Stats.accuracy_level, Stats.accuracy_xp, Stats.accuracy_xp_to_next_level(), Stats.accuracy_progress_ratio())
	hud.set_economy(Economy.money, Skills.training_manual_level, Skills.get_training_manual_cost(), Skills.can_buy_training_manual())
	hud.set_bows(player.bow_inventory.get_all_bows(), player.bow_inventory.owned, player.bow_inventory.equipped_bow_id, Economy.money, Stats.strength_level)
	hud.set_range_level(range_level, MAX_RANGE_LEVEL, RANGE_LEVEL_COSTS, Economy.money)

func _reset_session() -> void:
	impact_position = Vector2.ZERO
	impact_timer = 0.0
	shot_result_timer = 0.0
	equipment_open = false
	total_coins_earned = 0
	shots_fired = 0
	successful_hits = 0
	bullseyes = 0
	player.set_input_enabled(true)
	world_view.clear_arrows()
	hud.set_equipment_visible(false)
	hud.hide_shot_result()
	_refresh_hud()
