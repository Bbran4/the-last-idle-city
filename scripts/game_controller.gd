extends Node2D

@onready var castle: Castle = $Castle
@onready var player: Player = $Player
@onready var wave_manager: WaveManager = $WaveManager
@onready var upgrade_manager: UpgradeManager = $UpgradeManager

func _ready() -> void:
	GameState.start_game()
	castle.health_changed.connect(_on_castle_health_changed)
	_on_castle_health_changed(castle.health, castle.max_health)
	upgrade_manager.setup(player, castle)
	wave_manager.setup(castle)
	wave_manager.start()

func _on_castle_health_changed(current: float, maximum: float) -> void:
	var ui := $UI as GameUI
	if ui:
		ui.set_castle_health(current, maximum)
