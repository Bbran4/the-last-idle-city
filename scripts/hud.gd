class_name HUD
extends Control

signal training_upgrade_pressed

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

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	draw_bar.visible = false
	shot_result_label.visible = false
	strength_gain_label.visible = false
	accuracy_gain_label.visible = false
	economy_feedback_label.visible = false
	training_upgrade_button.pressed.connect(_on_training_upgrade_pressed)

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
