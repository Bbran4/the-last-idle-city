extends Control

@onready var materials_label: Label = $UI/MarginContainer/VBoxContainer/MaterialsLabel
@onready var production_label: Label = $UI/MarginContainer/VBoxContainer/ProductionLabel
@onready var scrap_yard_level_label: Label = $UI/MarginContainer/VBoxContainer/ScrapYardLevelLabel
@onready var scrap_yard_count_label: Label = $UI/MarginContainer/VBoxContainer/ScrapYardCountLabel
@onready var milestone_label: Label = $UI/MarginContainer/VBoxContainer/MilestoneLabel
@onready var tick_label: Label = $UI/MarginContainer/VBoxContainer/TickLabel
@onready var level_up_button: Button = $UI/MarginContainer/VBoxContainer/LevelUpButton
@onready var build_new_button: Button = $UI/MarginContainer/VBoxContainer/BuildNewButton
@onready var manual_production_button: Button = $UI/MarginContainer/VBoxContainer/ManualProductionButton
@onready var production_feedback_label: Label = $UI/MarginContainer/VBoxContainer/ProductionFeedbackLabel
@onready var game_clock: GameClock = $GameClock
@onready var save_button: Button = $UI/MarginContainer/VBoxContainer/SaveLoadContainer/SaveButton
@onready var load_button: Button = $UI/MarginContainer/VBoxContainer/SaveLoadContainer/LoadButton

var production_feedback_tween: Tween

func _ready() -> void:
	game_clock.tick.connect(_on_game_tick)

	save_button.pressed.connect(_on_save_pressed)
	load_button.pressed.connect(_on_load_pressed)
	level_up_button.pressed.connect(_on_level_up_pressed)
	build_new_button.pressed.connect(_on_build_new_pressed)
	manual_production_button.pressed.connect(_on_manual_production_pressed)

	_update_ui()


func _on_game_tick(delta: float) -> void:
	_update_ui()
	_show_production_feedback(GameState.data.scrap_yard_production_per_second() * delta)


func _update_ui() -> void:
	materials_label.text = "Materials: %s" % NumberFormatter.format_number(GameState.data.materials)
	production_label.text = "Total production: %s Materials/sec" % NumberFormatter.format_number(GameState.data.scrap_yard_production_per_second())
	scrap_yard_level_label.text = "Scrap Yard level: %d" % GameState.data.scrap_yard_level
	scrap_yard_count_label.text = "Scrap Yards: %d (×%d)" % [GameState.data.scrap_yard_count, GameState.data.scrap_yard_count]
	milestone_label.text = "Milestone multiplier: ×%s | Next expansion: level %d" % [
		NumberFormatter.format_number(GameState.data.scrap_yard_milestone_multiplier()),
		GameState.data.scrap_yard_next_milestone_level()
	]
	level_up_button.text = "LEVEL UP (%s Materials)" % NumberFormatter.format_number(GameState.data.scrap_yard_level_up_cost())
	level_up_button.disabled = not GameState.data.can_level_up_scrap_yard()
	build_new_button.text = "BUILD NEW (%s Materials)" % NumberFormatter.format_number(GameState.data.scrap_yard_build_new_cost())
	build_new_button.disabled = not GameState.data.can_build_new_scrap_yard()
	manual_production_button.text = "PROCESS SCRAP (+%s Materials)" % NumberFormatter.format_number(GameState.data.scrap_yard_manual_production())
	tick_label.text = "Game Time: %.0fs | Ticks: %d" % [
		GameState.data.game_time,
		GameState.data.total_ticks
	]

func _on_save_pressed() -> void:
	SaveManager.save_game()


func _on_load_pressed() -> void:
	if SaveManager.load_game():
		_update_ui()


func _on_level_up_pressed() -> void:
	if GameState.data.level_up_scrap_yard():
		_update_ui()


func _on_build_new_pressed() -> void:
	if GameState.data.build_new_scrap_yard():
		_update_ui()


func _on_manual_production_pressed() -> void:
	var amount := GameState.data.scrap_yard_manual_production()
	GameState.data.produce_materials(amount)
	_update_ui()
	_show_production_feedback(amount)


func _show_production_feedback(amount: float) -> void:
	production_feedback_label.text = "+%s Materials" % NumberFormatter.format_number(amount)
	production_feedback_label.modulate = Color(1.0, 0.85, 0.35, 1.0)
	production_feedback_label.scale = Vector2.ONE

	if production_feedback_tween:
		production_feedback_tween.kill()

	production_feedback_tween = create_tween()
	production_feedback_tween.set_parallel()
	production_feedback_tween.tween_property(production_feedback_label, "modulate:a", 0.0, 0.6)
	production_feedback_tween.tween_property(production_feedback_label, "scale", Vector2(1.12, 1.12), 0.6)
