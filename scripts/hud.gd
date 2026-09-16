class_name HUD
extends Control

signal training_upgrade_pressed
signal bow_action_requested(bow_id: String)

const DRAW_BAR_WIDTH: float = 360.0

@onready var score_label: Label = $ScoreLabel
@onready var stats_label: Label = $StatsLabel
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

var equipment_panel: PanelContainer
var equipment_list: VBoxContainer

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	draw_bar.visible = false
	shot_result_label.visible = false
	strength_gain_label.visible = false
	accuracy_gain_label.visible = false
	economy_feedback_label.visible = false
	training_upgrade_button.pressed.connect(_on_training_upgrade_pressed)
	_create_equipment_panel()

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
		else:
			button.text = "%s  $%d  STR %d" % [bow.display_name, bow.price, bow.required_strength]
			button.disabled = money < bow.price or strength_level < bow.required_strength
		button.pressed.connect(_on_bow_button_pressed.bind(bow.id))
		equipment_list.add_child(button)

func _on_bow_button_pressed(bow_id: String) -> void:
	bow_action_requested.emit(bow_id)

func set_score(score: int) -> void:
	score_label.text = "SCORE  %d" % score

func set_stats(shots: int, hits: int, bullseyes: int) -> void:
	stats_label.text = "SHOTS  %d    HITS  %d    BULLSEYES  %d" % [shots, hits, bullseyes]

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
