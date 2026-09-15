class_name GameUI
extends Control

@onready var wave_label: Label = get_node_or_null("WaveLabel")
@onready var coins_label: Label = get_node_or_null("CoinsLabel")
@onready var castle_health_label: Label = get_node_or_null("CastleHealthLabel")
@onready var wave_status_label: Label = get_node_or_null("WaveStatusLabel")
@onready var passive_label: Label = get_node_or_null("PassiveLabel")

func _ready() -> void:
	GameState.wave_changed.connect(_on_wave_changed)
	Economy.coins_changed.connect(_on_coins_changed)
	var castle := get_node_or_null("../Castle") as Castle
	if castle:
		castle.health_changed.connect(set_castle_health)
		set_castle_health(castle.health, castle.max_health)
	var wave_manager := get_node_or_null("../WaveManager") as WaveManager
	if wave_manager:
		wave_manager.wave_started.connect(_on_wave_started)
		wave_manager.wave_completed.connect(_on_wave_completed)
	var upgrade_manager := get_node_or_null("../UpgradeManager") as UpgradeManager
	if upgrade_manager:
		upgrade_manager.passive_unlocked.connect(_on_passive_unlocked)
		set_passive_text(upgrade_manager.get_first_passive_text())
	_on_wave_changed(GameState.current_wave)
	_on_coins_changed(Economy.get_coins())

func _on_wave_changed(wave: int) -> void:
	if wave_label:
		wave_label.text = "Wave: %d" % wave

func _on_coins_changed(amount: int) -> void:
	if coins_label:
		coins_label.text = "Coins: %d" % amount

func _on_wave_started(wave: int) -> void:
	if wave_status_label:
		wave_status_label.text = "Wave %d: enemies incoming" % wave

func _on_wave_completed(wave: int) -> void:
	if wave_status_label:
		wave_status_label.text = "Wave %d cleared. Next wave incoming..." % wave

func _on_passive_unlocked(_display_name: String) -> void:
	set_passive_text("Passive: Sharpened Arrows (+1 Damage)")
	if wave_status_label:
		wave_status_label.text = "Passive unlocked: +1 Damage"

func set_passive_text(text: String) -> void:
	if passive_label:
		passive_label.text = text

func set_castle_health(current: float, maximum: float) -> void:
	if castle_health_label:
		castle_health_label.text = "Castle: %.0f / %.0f" % [current, maximum]
