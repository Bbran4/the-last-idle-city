extends Node2D

const IMPACT_FLASH_DURATION: float = 0.18
const SHOT_RESULT_DURATION: float = 1.5
const SHOT_RECOVERY_TIME: float = 1.0

@onready var world_view: WorldView = $WorldView
@onready var hud: HUD = $HUD

var stats: PlayerStats = PlayerStats.new()
var economy: PlayerEconomy = PlayerEconomy.new()
var bow_inventory: BowInventory = BowInventory.new()
var draw_strength: float = 0.0
var is_drawing: bool = false
var shot_recovery_timer: float = 0.0
var impact_position: Vector2 = Vector2.ZERO
var impact_timer: float = 0.0
var aim_angle: float = 0.0
var shot_result_timer: float = 0.0

var total_score: int = 0
var shots_fired: int = 0
var successful_hits: int = 0
var bullseyes: int = 0

func _ready() -> void:
	world_view.configure_bow(bow_inventory.get_equipped())
	hud.training_upgrade_pressed.connect(_on_training_upgrade_pressed)
	hud.bow_action_requested.connect(_on_bow_action_requested)
	_refresh_hud()

func _process(delta: float) -> void:
	_update_aim()
	var bow: BowData = bow_inventory.get_equipped()
	shot_recovery_timer = max(shot_recovery_timer - delta, 0.0)
	if is_drawing:
		draw_strength = min(draw_strength + bow.draw_speed * delta, bow.max_draw_strength)
	if impact_timer > 0.0:
		impact_timer = max(impact_timer - delta, 0.0)
	if shot_result_timer > 0.0:
		shot_result_timer = max(shot_result_timer - delta, 0.0)
		if shot_result_timer <= 0.0:
			hud.hide_shot_result()
	var draw_ratio: float = draw_strength / bow.max_draw_strength
	var preview_speed: float = 0.0
	if is_drawing:
		preview_speed = stats.get_max_launch_speed(lerp(bow.min_launch_speed, bow.max_launch_speed, draw_ratio))
	world_view.set_draw_ratio(draw_ratio)
	world_view.set_trajectory(aim_angle, draw_ratio, preview_speed, stats.get_trajectory_prediction_quality(), is_drawing)
	world_view.update_impact(impact_position, impact_timer)
	hud.set_draw_strength(draw_ratio, is_drawing)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_R:
		_reset_session()
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and not is_drawing and shot_recovery_timer <= 0.0:
			is_drawing = true
			draw_strength = 0.0
		elif not event.pressed and is_drawing:
			_release_arrow()

func _update_aim() -> void:
	var aim_vector: Vector2 = world_view.get_world_mouse_position() - world_view.get_bow_position()
	if aim_vector.length_squared() > 0.001:
		aim_angle = aim_vector.angle()
	world_view.aim_bow(aim_angle)

func _release_arrow() -> void:
	is_drawing = false
	shot_recovery_timer = SHOT_RECOVERY_TIME
	if draw_strength <= 0.0:
		draw_strength = 0.0
		return
	var bow: BowData = bow_inventory.get_equipped()
	var strength_ratio: float = draw_strength / bow.max_draw_strength
	var launch_speed: float = lerp(bow.min_launch_speed, bow.max_launch_speed, strength_ratio)
	launch_speed = stats.get_max_launch_speed(launch_speed)
	var strength_xp: int = stats.award_strength_release_xp(strength_ratio, economy.get_xp_multiplier())
	var arrow: Arrow = world_view.fire_arrow(Vector2.RIGHT.rotated(aim_angle), launch_speed)
	arrow.hit_target.connect(_on_arrow_hit)
	arrow.missed.connect(_on_arrow_missed)
	shots_fired += 1
	_show_result("SHOT FIRED")
	if strength_xp > 0:
		hud.show_strength_xp_gain(strength_xp)
	draw_strength = 0.0
	_refresh_hud()

func _on_arrow_hit(position: Vector2) -> void:
	var score_result: Dictionary = world_view.get_target().calculate_score(position)
	total_score += score_result.score
	successful_hits += 1
	var accuracy_xp: int = stats.award_accuracy_hit_xp(economy.get_xp_multiplier())
	if accuracy_xp > 0:
		hud.show_accuracy_xp_gain(accuracy_xp)
	if score_result.is_bullseye:
		bullseyes += 1
	impact_position = position
	impact_timer = IMPACT_FLASH_DURATION
	_show_result(score_result.label)

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
	else:
		if not bow_inventory.can_purchase(bow_id, economy.money, stats.strength_level):
			if stats.strength_level < bow.required_strength:
				hud.show_economy_feedback("REQUIRES STRENGTH %d" % bow.required_strength)
			else:
				hud.show_economy_feedback("NOT ENOUGH COINS  $%d" % bow.price)
			return
		if economy.spend_money(bow.price):
			var purchased_cost: int = bow_inventory.purchase(bow_id, economy.money + bow.price, stats.strength_level)
			if purchased_cost >= 0 and bow_inventory.equip(bow_id, stats.strength_level):
				world_view.configure_bow(bow)
				hud.show_economy_feedback("PURCHASED AND EQUIPPED  %s" % bow.display_name)
			else:
				hud.show_economy_feedback("PURCHASE FAILED")
		else:
			hud.show_economy_feedback("NOT ENOUGH COINS  $%d" % bow.price)
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
	hud.set_bows(bow_inventory.get_all_bows(), bow_inventory.owned, bow_inventory.equipped_bow_id, economy.money, stats.strength_level)

func _reset_session() -> void:
	is_drawing = false
	draw_strength = 0.0
	shot_recovery_timer = 0.0
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
