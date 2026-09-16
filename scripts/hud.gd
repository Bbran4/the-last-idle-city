class_name HUD
extends Control

const DRAW_BAR_WIDTH: float = 360.0

@onready var score_label: Label = $ScoreLabel
@onready var stats_label: Label = $StatsLabel
@onready var strength_label: Label = $StrengthLabel
@onready var strength_xp_label: Label = $StrengthXPLabel
@onready var strength_gain_label: Label = $StrengthGainLabel
@onready var shot_result_label: Label = $ShotResultLabel
@onready var draw_bar: Control = $DrawBar
@onready var draw_bar_fill: ColorRect = $DrawBar/Fill
@onready var draw_label: Label = $DrawBar/DrawLabel

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	draw_bar.visible = false
	shot_result_label.visible = false
	strength_gain_label.visible = false

func set_score(score: int) -> void:
	score_label.text = "SCORE  %d" % score

func set_stats(shots: int, hits: int, bullseyes: int) -> void:
	stats_label.text = "SHOTS  %d    HITS  %d    BULLSEYES  %d" % [shots, hits, bullseyes]

func set_strength(level: int, xp: int, xp_to_next: int, progress_ratio: float) -> void:
	strength_label.text = "STRENGTH  %d" % level
	strength_xp_label.text = "XP  %d / %d" % [xp, xp_to_next]

func show_strength_xp_gain(amount: int) -> void:
	strength_gain_label.text = "+%d STRENGTH XP" % amount
	strength_gain_label.visible = true

func show_shot_result(text: String) -> void:
	shot_result_label.text = text
	shot_result_label.visible = true

func hide_shot_result() -> void:
	shot_result_label.visible = false
	strength_gain_label.visible = false

func set_draw_strength(ratio: float, drawing: bool) -> void:
	draw_bar.visible = drawing
	draw_bar_fill.size.x = DRAW_BAR_WIDTH * clamp(ratio, 0.0, 1.0)
	draw_label.text = "DRAW  %d%%" % int(ratio * 100.0)
