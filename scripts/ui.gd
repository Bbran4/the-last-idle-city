class_name GameUI
extends Control

@onready var wave_label: Label = get_node_or_null("WaveLabel")
@onready var coins_label: Label = get_node_or_null("CoinsLabel")
@onready var castle_health_label: Label = get_node_or_null("CastleHealthLabel")

func _ready() -> void:
	GameState.wave_changed.connect(_on_wave_changed)
	Economy.coins_changed.connect(_on_coins_changed)
	var castle := get_node_or_null("../Castle") as Castle
	if castle:
		castle.health_changed.connect(set_castle_health)
		set_castle_health(castle.health, castle.max_health)
	_on_wave_changed(GameState.current_wave)
	_on_coins_changed(Economy.get_coins())

func _on_wave_changed(wave: int) -> void:
	if wave_label:
		wave_label.text = "Wave: %d" % wave

func _on_coins_changed(amount: int) -> void:
	if coins_label:
		coins_label.text = "Coins: %d" % amount

func set_castle_health(current: float, maximum: float) -> void:
	if castle_health_label:
		castle_health_label.text = "Castle: %.0f / %.0f" % [current, maximum]
