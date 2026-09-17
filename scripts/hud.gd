class_name HUD
extends Control

signal training_upgrade_pressed
signal bow_action_requested(bow_id: String)
signal range_upgrade_requested

const DRAW_BAR_WIDTH: float = 360.0

@onready var strength_label: Label = $StrengthLabel
@onready var strength_xp_label: Label = $StrengthXPLabel
@onready var accuracy_label: Label = $AccuracyLabel
@onready var accuracy_xp_label: Label = $AccuracyXPLabel
@onready var strength_gain_label: Label = $StrengthGainLabel
@onready var accuracy_gain_label: Label = $AccuracyGainLabel
@onready var shot_result_label: Label = $ShotResultLabel
@onready var money_label: Label = $EconomyPanel/MoneyLabel
@onready var training_upgrade_button: Button = $EconomyPanel/TrainingUpgradeButton
@onready var economy_feedback_label: Label = $EconomyPanel/FeedbackLabel
@onready var draw_bar: Control = $DrawBar
@onready var draw_bar_fill: ColorRect = $DrawBar/Fill
@onready var draw_label: Label = $DrawBar/DrawLabel
@onready var interaction_label: Label = $InteractionLabel

var equipment_panel: PanelContainer
var equipment_list: VBoxContainer
var range_panel: PanelContainer
var range_list: VBoxContainer

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	draw_bar.visible = false
	shot_result_label.visible = false
	strength_gain_label.visible = false
	accuracy_gain_label.visible = false
	economy_feedback_label.visible = false
	interaction_label.visible = false
	training_upgrade_button.pressed.connect(_on_training_upgrade_pressed)
	_create_equipment_panel()
	_create_range_panel()
	equipment_panel.visible = false

func _create_equipment_panel() -> void:
	equipment_panel = PanelContainer.new()
	equipment_panel.position = Vector2(24.0, 250.0)
	equipment_panel.size = Vector2(306.0, 220.0)
	equipment_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(equipment_panel)
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_top", 10)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_bottom", 10)
	equipment_panel.add_child(margin)
	equipment_list = VBoxContainer.new()
	equipment_list.add_theme_constant_override("separation", 6)
	margin.add_child(equipment_list)
	var title := Label.new()
	title.text = "BOW EQUIPMENT"
	title.add_theme_font_size_override("font_size", 18)
	equipment_list.add_child(title)

func _create_range_panel() -> void:
	range_panel = PanelContainer.new()
	range_panel.position = Vector2(954.0, 250.0)
	range_panel.size = Vector2(306.0, 330.0)
	range_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(range_panel)
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_top", 10)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_bottom", 10)
	range_panel.add_child(margin)
	range_list = VBoxContainer.new()
	range_list.add_theme_constant_override("separation", 6)
	margin.add_child(range_list)
	var title := Label.new()
	title.text = "PRACTICE RANGE"
	title.add_theme_font_size_override("font_size", 18)
	range_list.add_child(title)

func set_equipment_visible(visible: bool) -> void:
	if equipment_panel != null:
		equipment_panel.visible = visible

func set_tent_prompt(near_tent: bool, equipment_open: bool) -> void:
	if interaction_label == null:
		return
	if not near_tent:
		interaction_label.visible = false
		return
	interaction_label.visible = true
	interaction_label.text = "E  CLOSE EQUIPMENT" if equipment_open else "E  OPEN EQUIPMENT"

func set_bows(bows: Array[BowData], owned: Dictionary, equipped_id: String, money: int, strength_level: int) -> void:
	if equipment_list == null:
		return
	for child in equipment_list.get_children():
		if child is Button:
			child.queue_free()
	for bow: BowData in bows:
		var button := Button.new()
		button.custom_minimum_size = Vector2(0, 34)
		button.mouse_filter = Control.MOUSE_FILTER_STOP
		var is_owned: bool = owned.get(bow.id, false)
		var is_equipped: bool = bow.id == equipped_id
		if is_equipped:
			button.text = "%s  [EQUIPPED]" % bow.display_name
			button.disabled = true
		elif is_owned:
			button.text = "%s  [EQUIP]" % bow.display_name
			button.pressed.connect(_on_bow_button_pressed.bind(bow.id))
		else:
			button.text = "%s  $%d  STR %d" % [bow.display_name, bow.price, bow.required_strength]
			button.disabled = money < bow.price or strength_level < bow.required_strength
			button.pressed.connect(_on_bow_button_pressed.bind(bow.id))
		equipment_list.add_child(button)

func set_range_level(level: int, max_level: int, costs: Array[int], money: int) -> void:
	if range_list == null:
		return
	for child in range_list.get_children():
		if child is Button or child is Label and child != range_list.get_child(0):
			child.queue_free()

	var status := Label.new()
	status.text = "RANGE LEVEL  %d / %d" % [level, max_level]
	range_list.add_child(status)

	var target_names: Array[String] = ["LARGE TARGET", "SMALL TARGET", "DISTANT TARGET", "RING TARGET"]
	var target_rewards: Array[int] = [1, 2, 3, 5]
	for index: int in range(max_level):
		var target_label := Label.new()
		var unlocked: bool = index < level
		if unlocked:
			target_label.text = "%s  +%d COINS  [UNLOCKED]" % [target_names[index], target_rewards[index]]
		else:
			target_label.text = "%s  +%d COINS  [LOCKED]" % [target_names[index], target_rewards[index]]
		range_list.add_child(target_label)

	if level < max_level:
		var next_cost: int = costs[level]
		var upgrade_button := Button.new()
		upgrade_button.custom_minimum_size = Vector2(0, 34)
		upgrade_button.mouse_filter = Control.MOUSE_FILTER_STOP
		upgrade_button.text = "UPGRADE RANGE  $%d" % next_cost
		upgrade_button.disabled = money < next_cost
		upgrade_button.pressed.connect(_on_range_upgrade_button_pressed)
		range_list.add_child(upgrade_button)
	else:
		var max_label := Label.new()
		max_label.text = "RANGE FULLY UPGRADED"
		range_list.add_child(max_label)

func _on_bow_button_pressed(bow_id: String) -> void:
	bow_action_requested.emit(bow_id)

func _on_range_upgrade_button_pressed() -> void:
	range_upgrade_requested.emit()

func set_coins_earned(_amount: int) -> void:
	# Kept as a compatibility hook for the practice-session statistics code.
	# The persistent economy display is now the only coin counter shown to the player.
	pass

func set_stats(_shots: int, _hits: int, _bullseyes: int) -> void:
	# Session shot counters are development telemetry and are intentionally not shown in the release HUD.
	pass

func set_strength(level: int, xp: int, xp_to_next: int, _progress_ratio: float) -> void:
	strength_label.text = "STRENGTH  %d" % level
	strength_xp_label.text = "XP  %d / %d" % [xp, xp_to_next]

func set_accuracy(level: int, xp: int, xp_to_next: int, _progress_ratio: float) -> void:
	accuracy_label.text = "ACCURACY  %d" % level
	accuracy_xp_label.text = "XP  %d / %d" % [xp, xp_to_next]

func show_strength_xp_gain(amount: int) -> void:
	strength_gain_label.text = "+%d STRENGTH XP" % amount
	strength_gain_label.visible = true

func show_accuracy_xp_gain(amount: int) -> void:
	accuracy_gain_label.text = "+%d ACCURACY XP" % amount
	accuracy_gain_label.visible = true

func show_stat_level_up(stat_name: String, level: int) -> void:
	show_shot_result("%s LEVEL UP  %d" % [stat_name, level])

func show_shot_result(text: String) -> void:
	shot_result_label.text = text
	shot_result_label.visible = true

func hide_shot_result() -> void:
	shot_result_label.visible = false
	strength_gain_label.visible = false
	accuracy_gain_label.visible = false

func set_draw_strength(ratio: float, drawing: bool) -> void:
	draw_bar.visible = drawing
	draw_bar_fill.size.x = DRAW_BAR_WIDTH * clamp(ratio, 0.0, 1.0)
	draw_label.text = "DRAW  %d%%" % int(ratio * 100.0)

func set_economy(money: int, training_level: int, training_cost: int, can_buy: bool) -> void:
	money_label.text = "COINS  %d" % money
	if training_level >= 5:
		training_upgrade_button.text = "TRAINING MANUAL  MAX"
		training_upgrade_button.disabled = true
	else:
		training_upgrade_button.text = "TRAINING MANUAL  $%d  [%d/5]" % [training_cost, training_level]
		training_upgrade_button.disabled = not can_buy

func show_economy_feedback(text: String) -> void:
	economy_feedback_label.text = text
	economy_feedback_label.visible = true

func _on_training_upgrade_pressed() -> void:
	training_upgrade_pressed.emit()
