class_name GameUI
extends Control

@onready var wave_label: Label = get_node_or_null("WaveLabel")
@onready var coins_label: Label = get_node_or_null("CoinsLabel")
@onready var castle_health_label: Label = get_node_or_null("CastleHealthLabel")

func _ready() -> void:
	if Engine.has_singleton("GameState"):
		GameState.wave_changed.connect(_on_wave_changed)
	if Engine.has_singleton("Economy"):
		Economy.coins_changed.connect(_on_coins_changed)

func _on_wave_changed(wave: int) -> void:
	if wave_label:
		wave_label.text = "Wave: %d" % wave

func _on_coins_changed(amount: int) -> void:
	if coins_label:
		coins_label.text = "Coins: %d" % amount

func set_castle_health(current: float, maximum: float) -> void:
	if castle_health_label:
		castle_health_label.text = "Castle: %.0f / %.0f" % [current, maximum]
