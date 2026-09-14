extends Control

@onready var materials_label: Label = $UI/MarginContainer/VBoxContainer/MaterialsLabel
@onready var production_label: Label = $UI/MarginContainer/VBoxContainer/ProductionLabel
@onready var population_label: Label = $UI/MarginContainer/VBoxContainer/PopulationLabel
@onready var workforce_label: Label = $UI/MarginContainer/VBoxContainer/WorkforceLabel
@onready var industrial_allocation_label: Label = $UI/MarginContainer/VBoxContainer/IndustrialAllocationLabel
@onready var allocation_slider: HSlider = $UI/MarginContainer/VBoxContainer/IndustrialAllocationSlider
@onready var allocation_feedback_label: Label = $UI/MarginContainer/VBoxContainer/AllocationFeedbackLabel
@onready var chain_status_label: Label = $UI/MarginContainer/VBoxContainer/ChainStatusLabel
@onready var production_stats_label: Label = $UI/MarginContainer/VBoxContainer/ProductionStatsLabel
@onready var reclamation_depot_label: Label = $UI/MarginContainer/VBoxContainer/ReclamationDepotLabel
@onready var reclamation_depot_unlock_button: Button = $UI/MarginContainer/VBoxContainer/ReclamationDepotUnlockButton
@onready var reclamation_depot_level_up_button: Button = $UI/MarginContainer/VBoxContainer/ReclamationDepotLevelUpButton
@onready var reclamation_depot_build_new_button: Button = $UI/MarginContainer/VBoxContainer/ReclamationDepotBuildNewButton
@onready var workshop_label: Label = $UI/MarginContainer/VBoxContainer/WorkshopLabel
@onready var workshop_unlock_button: Button = $UI/MarginContainer/VBoxContainer/WorkshopUnlockButton
@onready var workshop_level_up_button: Button = $UI/MarginContainer/VBoxContainer/WorkshopLevelUpButton
@onready var workshop_build_new_button: Button = $UI/MarginContainer/VBoxContainer/WorkshopBuildNewButton
@onready var factory_label: Label = $UI/MarginContainer/VBoxContainer/FactoryLabel
@onready var factory_unlock_button: Button = $UI/MarginContainer/VBoxContainer/FactoryUnlockButton
@onready var factory_level_up_button: Button = $UI/MarginContainer/VBoxContainer/FactoryLevelUpButton
@onready var factory_build_new_button: Button = $UI/MarginContainer/VBoxContainer/FactoryBuildNewButton
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
	allocation_slider.value_changed.connect(_on_industrial_allocation_changed)
	reclamation_depot_unlock_button.pressed.connect(_on_reclamation_depot_unlock_pressed)
	reclamation_depot_level_up_button.pressed.connect(_on_reclamation_depot_level_up_pressed)
	reclamation_depot_build_new_button.pressed.connect(_on_reclamation_depot_build_new_pressed)
	workshop_unlock_button.pressed.connect(_on_workshop_unlock_pressed)
	workshop_level_up_button.pressed.connect(_on_workshop_level_up_pressed)
	workshop_build_new_button.pressed.connect(_on_workshop_build_new_pressed)
	factory_unlock_button.pressed.connect(_on_factory_unlock_pressed)
	factory_level_up_button.pressed.connect(_on_factory_level_up_pressed)
	factory_build_new_button.pressed.connect(_on_factory_build_new_pressed)

	_update_ui()


func _on_game_tick(delta: float) -> void:
	_update_ui()
	_show_production_feedback(GameState.data.scrap_yard_production_per_second() * delta)


func _update_ui() -> void:
	materials_label.text = "Materials: %s" % NumberFormatter.format_number(GameState.data.materials)
	production_label.text = "Total production: %s Materials/sec" % NumberFormatter.format_number(GameState.data.scrap_yard_production_per_second())
	population_label.text = "Population: %s (+%s/sec)" % [
		NumberFormatter.format_number(GameState.data.population),
		NumberFormatter.format_number(GameData.POPULATION_GROWTH_PER_SECOND)
	]
	workforce_label.text = "Available workforce: %s | Industrial: %s" % [
		NumberFormatter.format_number(GameState.data.workforce_available()),
		NumberFormatter.format_number(GameState.data.industrial_workforce_count())
	]
	industrial_allocation_label.text = "Industrial Authority allocation: %.0f%%" % GameState.data.industrial_allocation_percent
	allocation_slider.set_value_no_signal(GameState.data.industrial_allocation_percent)
	_update_allocation_feedback()
	chain_status_label.text = "Automated chain: Factory ×%.2f → Workshop ×%.2f → Reclamation ×%.2f → Scrap Yard" % [
		GameState.data.factory_multiplier(),
		GameState.data.workshop_multiplier(),
		GameState.data.reclamation_depot_multiplier()
	]
	production_stats_label.text = "Lifetime Materials produced: %s" % NumberFormatter.format_number(GameState.data.total_materials_produced)
	scrap_yard_level_label.text = "Scrap Yard level: %d" % GameState.data.scrap_yard_level
	scrap_yard_count_label.text = "Scrap Yards: %d (×%d)" % [GameState.data.scrap_yard_count, GameState.data.scrap_yard_count]
	milestone_label.text = "Milestone productivity: ×%s | Next double: level %d" % [
		NumberFormatter.format_number(GameState.data.scrap_yard_milestone_multiplier()),
		GameState.data.scrap_yard_next_milestone_level()
	]
	level_up_button.text = "LEVEL UP (%s Materials)" % NumberFormatter.format_number(GameState.data.scrap_yard_level_up_cost())
	level_up_button.disabled = not GameState.data.can_level_up_scrap_yard()
	build_new_button.text = "BUILD NEW (%s Materials)" % NumberFormatter.format_number(GameState.data.scrap_yard_build_new_cost())
	build_new_button.disabled = not GameState.data.can_build_new_scrap_yard()
	manual_production_button.text = "PROCESS SCRAP (+%s Materials)" % NumberFormatter.format_number(GameState.data.scrap_yard_manual_production())
	_update_operation_ui(
		GameState.data.reclamation_depot,
		reclamation_depot_label,
		reclamation_depot_unlock_button,
		reclamation_depot_level_up_button,
		reclamation_depot_build_new_button,
		"Requires %s Materials" % NumberFormatter.format_number(GameData.RECLAMATION_DEPOT_UNLOCK_COST),
		GameState.data.can_unlock_reclamation_depot()
	)
	_update_operation_ui(
		GameState.data.workshop,
		workshop_label,
		workshop_unlock_button,
		workshop_level_up_button,
		workshop_build_new_button,
		"Requires Reclamation Depot level %d and %s Materials" % [ProductionOperation.MILESTONE_INTERVAL, NumberFormatter.format_number(GameData.WORKSHOP_UNLOCK_COST)],
		GameState.data.can_unlock_workshop()
	)
	_update_operation_ui(
		GameState.data.factory,
		factory_label,
		factory_unlock_button,
		factory_level_up_button,
		factory_build_new_button,
		"Requires Workshop level %d and %s Materials" % [ProductionOperation.MILESTONE_INTERVAL, NumberFormatter.format_number(GameData.FACTORY_UNLOCK_COST)],
		GameState.data.can_unlock_factory()
	)
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


func _on_industrial_allocation_changed(value: float) -> void:
	GameState.data.set_industrial_allocation_percent(value)
	_update_ui()


func _on_reclamation_depot_unlock_pressed() -> void:
	if GameState.data.unlock_operation(GameState.data.reclamation_depot):
		_update_ui()


func _on_reclamation_depot_level_up_pressed() -> void:
	if GameState.data.level_up_operation(GameState.data.reclamation_depot):
		_update_ui()


func _on_reclamation_depot_build_new_pressed() -> void:
	if GameState.data.build_new_operation(GameState.data.reclamation_depot):
		_update_ui()


func _on_workshop_unlock_pressed() -> void:
	if GameState.data.unlock_operation(GameState.data.workshop):
		_update_ui()


func _on_workshop_level_up_pressed() -> void:
	if GameState.data.level_up_operation(GameState.data.workshop):
		_update_ui()


func _on_workshop_build_new_pressed() -> void:
	if GameState.data.build_new_operation(GameState.data.workshop):
		_update_ui()


func _on_factory_unlock_pressed() -> void:
	if GameState.data.unlock_operation(GameState.data.factory):
		_update_ui()


func _on_factory_level_up_pressed() -> void:
	if GameState.data.level_up_operation(GameState.data.factory):
		_update_ui()


func _on_factory_build_new_pressed() -> void:
	if GameState.data.build_new_operation(GameState.data.factory):
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


func _update_allocation_feedback() -> void:
	var state := GameState.data.industrial_allocation_feedback_state()
	allocation_feedback_label.text = "%s allocation efficiency: %.0f%% | Efficient range: %.0f%%–%.0f%% | Scrap Yard: ×%.2f" % [
		state,
		GameState.data.industrial_allocation_efficiency() * 100.0,
		GameState.data.industrial_efficient_min_percent(),
		GameState.data.industrial_efficient_max_percent(),
		GameState.data.industrial_productivity_multiplier()
	]

	match state:
		"GREEN":
			allocation_feedback_label.modulate = Color(0.35, 0.9, 0.45)
		"ORANGE":
			allocation_feedback_label.modulate = Color(1.0, 0.65, 0.2)
		_:
			allocation_feedback_label.modulate = Color(1.0, 0.3, 0.3)


func _update_operation_ui(
	operation: ProductionOperation,
	status_label: Label,
	unlock_button: Button,
	level_up_button: Button,
	build_new_button: Button,
	unlock_requirement: String,
	can_unlock: bool
) -> void:
	if not operation.unlocked:
		status_label.text = "%s — LOCKED (%s)" % [operation.display_name, unlock_requirement]
		unlock_button.visible = true
		unlock_button.text = "UNLOCK %s (%s Materials)" % [operation.display_name.to_upper(), NumberFormatter.format_number(operation.unlock_cost)]
		unlock_button.disabled = not can_unlock
		level_up_button.visible = false
		build_new_button.visible = false
		return

	status_label.text = "%s — Level %d | Buildings %d | Milestone ×%s | Automation ACTIVE" % [
		operation.display_name,
		operation.level,
		operation.count,
		NumberFormatter.format_number(operation.milestone_multiplier())
	]
	unlock_button.visible = false
	level_up_button.visible = true
	level_up_button.text = "LEVEL UP (%s Materials)" % NumberFormatter.format_number(operation.level_up_cost())
	level_up_button.disabled = GameState.data.materials < operation.level_up_cost()
	build_new_button.visible = true
	build_new_button.text = "BUILD NEW (%s Materials)" % NumberFormatter.format_number(operation.build_new_cost())
	build_new_button.disabled = GameState.data.materials < operation.build_new_cost()
