extends Control

@onready var gold_label: Label = $UI/MarginContainer/VBoxContainer/GoldLabel
@onready var tick_label: Label = $UI/MarginContainer/VBoxContainer/TickLabel
@onready var game_clock: GameClock = $GameClock
@onready var save_button: Button = $UI/MarginContainer/VBoxContainer/SaveLoadContainer/SaveButton
@onready var load_button: Button = $UI/MarginContainer/VBoxContainer/SaveLoadContainer/LoadButton

func _ready() -> void:
	game_clock.tick.connect(_on_game_tick)

	save_button.pressed.connect(_on_save_pressed)
	load_button.pressed.connect(_on_load_pressed)

	_update_ui()


func _on_game_tick(_delta: float) -> void:
	_update_ui()


func _update_ui() -> void:
	gold_label.text = "Gold: %s" % NumberFormatter.format_number(GameState.data.gold)
	tick_label.text = "Game Time: %.0fs | Ticks: %d" % [
		GameState.data.game_time,
		GameState.data.total_ticks
	]

func _on_save_pressed() -> void:
	SaveManager.save_game()


func _on_load_pressed() -> void:
	if SaveManager.load_game():
		_update_ui()
