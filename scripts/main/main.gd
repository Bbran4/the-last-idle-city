extends Control

@onready var materials_label: Label = $UI/MarginContainer/VBoxContainer/MaterialsLabel
@onready var production_label: Label = $UI/MarginContainer/VBoxContainer/ProductionLabel
@onready var scrap_yard_level_label: Label = $UI/MarginContainer/VBoxContainer/ScrapYardLevelLabel
@onready var tick_label: Label = $UI/MarginContainer/VBoxContainer/TickLabel
@onready var level_up_button: Button = $UI/MarginContainer/VBoxContainer/LevelUpButton
@onready var game_clock: GameClock = $GameClock
@onready var save_button: Button = $UI/MarginContainer/VBoxContainer/SaveLoadContainer/SaveButton
@onready var load_button: Button = $UI/MarginContainer/VBoxContainer/SaveLoadContainer/LoadButton

func _ready() -> void:
	game_clock.tick.connect(_on_game_tick)

	save_button.pressed.connect(_on_save_pressed)
	load_button.pressed.connect(_on_load_pressed)
	level_up_button.pressed.connect(_on_level_up_pressed)

	_update_ui()


func _on_game_tick(_delta: float) -> void:
	_update_ui()


func _update_ui() -> void:
	materials_label.text = "Materials: %s" % NumberFormatter.format_number(GameState.data.materials)
	production_label.text = "Materials per second: %s" % NumberFormatter.format_number(GameState.data.scrap_yard_production_per_second())
	scrap_yard_level_label.text = "Scrap Yard level: %d" % GameState.data.scrap_yard_level
	level_up_button.text = "LEVEL UP (%s Materials)" % NumberFormatter.format_number(GameState.data.scrap_yard_level_up_cost())
	level_up_button.disabled = not GameState.data.can_level_up_scrap_yard()
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
