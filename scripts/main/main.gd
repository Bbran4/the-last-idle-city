extends Control

@onready var materials_label: Label = $Layout/VBox/Body/RightRail/VBox/MaterialsLabel
@onready var production_label: Label = $Layout/VBox/Body/Center/CityOverview/VBox/ProductionLabel
@onready var population_label: Label = $Layout/VBox/Body/RightRail/VBox/PopulationLabel
@onready var workforce_label: Label = $Layout/VBox/Body/RightRail/VBox/WorkforceLabel
@onready var industrial_allocation_label: Label = $Layout/VBox/Body/Center/WorkforcePanel/VBox/IndustrialAllocationLabel
@onready var allocation_slider: HSlider = $Layout/VBox/Body/Center/WorkforcePanel/VBox/IndustrialAllocationSlider
@onready var allocation_feedback_label: Label = $Layout/VBox/Body/Center/WorkforcePanel/VBox/AllocationFeedbackLabel
@onready var chain_status_label: Label = $Layout/VBox/Body/RightRail/VBox/ChainStatusLabel
@onready var production_stats_label: Label = $Layout/VBox/Body/RightRail/VBox/ProductionStatsLabel
@onready var reclamation_depot_label: Label = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/ReclamationCard/VBox/ReclamationDepotLabel
@onready var reclamation_depot_unlock_button: Button = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/ReclamationCard/VBox/ReclamationDepotUnlockButton
@onready var reclamation_depot_level_up_button: Button = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/ReclamationCard/VBox/ReclamationDepotLevelUpButton
@onready var reclamation_depot_build_new_button: Button = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/ReclamationCard/VBox/ReclamationDepotBuildNewButton
@onready var workshop_label: Label = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/WorkshopCard/VBox/WorkshopLabel
@onready var workshop_unlock_button: Button = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/WorkshopCard/VBox/WorkshopUnlockButton
@onready var workshop_level_up_button: Button = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/WorkshopCard/VBox/WorkshopLevelUpButton
@onready var workshop_build_new_button: Button = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/WorkshopCard/VBox/WorkshopBuildNewButton
@onready var factory_label: Label = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/FactoryCard/VBox/FactoryLabel
@onready var factory_unlock_button: Button = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/FactoryCard/VBox/FactoryUnlockButton
@onready var factory_level_up_button: Button = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/FactoryCard/VBox/FactoryLevelUpButton
@onready var factory_build_new_button: Button = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/FactoryCard/VBox/FactoryBuildNewButton
@onready var scrap_yard_level_label: Label = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/ScrapCard/VBox/ScrapYardLevelLabel
@onready var scrap_yard_count_label: Label = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/ScrapCard/VBox/ScrapYardCountLabel
@onready var milestone_label: Label = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/ScrapCard/VBox/MilestoneLabel
@onready var tick_label: Label = $Layout/VBox/Body/RightRail/VBox/TickLabel
@onready var level_up_button: Button = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/ScrapCard/VBox/LevelUpButton
@onready var build_new_button: Button = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/ScrapCard/VBox/BuildNewButton
@onready var manual_production_button: Button = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/ScrapCard/VBox/ManualProductionButton
@onready var production_feedback_label: Label = $Layout/VBox/Body/Center/CityOverview/VBox/ProductionFeedbackLabel
@onready var game_clock: GameClock = $GameClock
@onready var save_button: Button = $Layout/VBox/Body/RightRail/VBox/SaveLoadContainer/SaveButton
@onready var load_button: Button = $Layout/VBox/Body/RightRail/VBox/SaveLoadContainer/LoadButton
@onready var top_population_label: Label = $Layout/VBox/TopBar/HBox/TopPopulationLabel
@onready var top_materials_label: Label = $Layout/VBox/TopBar/HBox/TopMaterialsLabel
@onready var top_production_label: Label = $Layout/VBox/TopBar/HBox/TopProductionLabel

var milestone_button: Button
var production_feedback_tween: Tween

func _ready() -> void:
	$Layout.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	$Layout/VBox/Body.set_size_flags(Control.SIZE_EXPAND_FILL, Control.SIZE_EXPAND_FILL)
	_create_scrap_yard_milestone_button()
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

func _create_scrap_yard_milestone_button() -> void:
	var scrap_card_vbox: VBoxContainer = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/ScrapCard/VBox
	milestone_button = Button.new()
	milestone_button.name = "ScrapYardMilestoneButton"
	milestone_button.text = "MILESTONE"
	milestone_button.theme_override_styles.normal = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/ScrapCard/VBox/LevelUpButton.get_theme_stylebox("normal")
	milestone_button.theme_override_styles.disabled = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/ScrapCard/VBox/LevelUpButton.get_theme_stylebox("disabled")
	milestone_button.pressed.connect(_on_scrap_yard_milestone_pressed)
	scrap_card_vbox.add_child(milestone_button)
	scrap_card_vbox.move_child(milestone_button, scrap_card_vbox.get_child_count() - 2)

func _on_game_tick(delta: float) -> void:
	_update_ui()
	_show_production_feedback(GameState.data.scrap_yard_production_per_second().multiply_float(delta))

func _update_ui() -> void:
	var data: GameData = GameState.data
	materials_label.text = "Materials: %s" % NumberFormatter.format_number(data.materials)
	production_label.text = "Total production: %s Materials/sec" % NumberFormatter.format_number(data.scrap_yard_production_per_second())
	population_label.text = "Population: %s (+%s/sec)" % [NumberFormatter.format_number(data.population), NumberFormatter.format_number(GameData.POPULATION_GROWTH_PER_SECOND)]
	workforce_label.text = "Available workforce: %s | Industrial: %s" % [NumberFormatter.format_number(data.workforce_available()), NumberFormatter.format_number(data.industrial_workforce_count())]
	industrial_allocation_label.text = "Industrial Authority allocation: %.0f%%" % data.industrial_allocation_percent
	allocation_slider.set_value_no_signal(data.industrial_allocation_percent)
	_update_allocation_feedback()
	chain_status_label.text = "Automation: Factory +%s Workshop Levels/sec → Workshop +%s Depot Levels/sec → Reclamation +%s Scrap Yard Levels/sec" % [NumberFormatter.format_rate(data.factory_workshop_level_rate()), NumberFormatter.format_rate(data.workshop_reclamation_depot_level_rate()), NumberFormatter.format_rate(data.reclamation_depot_scrap_yard_level_rate())]
	production_stats_label.text = "Lifetime Materials produced: %s | Energy: %.1f" % [NumberFormatter.format_number(data.total_materials_produced), data.energy]
	scrap_yard_level_label.text = "Scrap Yard level: %d" % data.scrap_yard.level
	scrap_yard_count_label.text = "Scrap Yards: %d" % data.scrap_yard.count
	milestone_label.text = "Milestone productivity: ×%s | Next: level %d + %.1f Energy" % [NumberFormatter.format_number(data.scrap_yard_milestone_multiplier()), data.scrap_yard_next_milestone_level(), data.scrap_yard_next_milestone_energy_cost()]
	level_up_button.text = "LEVEL UP (%s Materials + %.1f Energy)" % [NumberFormatter.format_number(data.scrap_yard_level_up_cost()), data.scrap_yard.level_up_energy_cost]
	level_up_button.disabled = not data.can_level_up_scrap_yard()
	build_new_button.text = "BUILD SCRAP YARD (%s Materials)" % NumberFormatter.format_number(data.scrap_yard_build_new_cost())
	build_new_button.disabled = not data.can_build_new_scrap_yard()
	_update_scrap_yard_milestone_ui()
	manual_production_button.text = "PROCESS SCRAP (+%s Materials)" % NumberFormatter.format_number(data.scrap_yard_manual_production())
	_update_operation_ui(data.reclamation_depot, reclamation_depot_label, reclamation_depot_unlock_button, reclamation_depot_level_up_button, reclamation_depot_build_new_button, "Requires %s Materials" % NumberFormatter.format_number(GameData.RECLAMATION_DEPOT_UNLOCK_COST), data.can_unlock_reclamation_depot())
	_update_operation_ui(data.workshop, workshop_label, workshop_unlock_button, workshop_level_up_button, workshop_build_new_button, "Requires Reclamation Depot level %d and %s Materials" % [ProductionOperation.FIRST_MILESTONE_LEVEL, NumberFormatter.format_number(GameData.WORKSHOP_UNLOCK_COST)], data.can_unlock_workshop())
	_update_operation_ui(data.factory, factory_label, factory_unlock_button, factory_level_up_button, factory_build_new_button, "Requires Workshop level %d and %s Materials" % [ProductionOperation.FIRST_MILESTONE_LEVEL, NumberFormatter.format_number(GameData.FACTORY_UNLOCK_COST)], data.can_unlock_factory())
	tick_label.text = "Game Time: %.0fs | Ticks: %d" % [data.game_time, data.total_ticks]

func _update_scrap_yard_milestone_ui() -> void:
	if milestone_button == null:
		return
	var data: GameData = GameState.data
	milestone_button.text = "MILESTONE (%d + %.1f Energy)" % [data.scrap_yard_next_milestone_level(), data.scrap_yard_next_milestone_energy_cost()]
	milestone_button.disabled = not data.can_trigger_scrap_yard_milestone()

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

func _on_scrap_yard_milestone_pressed() -> void:
	if GameState.data.trigger_scrap_yard_milestone():
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
	var amount: BigNumber = GameState.data.scrap_yard_manual_production()
	GameState.data.produce_materials(amount)
	_update_ui()
	_show_production_feedback(amount)

func _show_production_feedback(amount: BigNumber) -> void:
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
	var state: String = GameState.data.industrial_allocation_feedback_state()
	allocation_feedback_label.text = "%s allocation efficiency: %.0f%% | Efficient range: %.0f%%–%.0f%% | Scrap Yard: ×%.2f" % [state, GameState.data.industrial_allocation_efficiency() * 100.0, GameState.data.industrial_efficient_min_percent(), GameState.data.industrial_efficient_max_percent(), GameState.data.industrial_productivity_multiplier()]
	match state:
		"GREEN": allocation_feedback_label.modulate = Color(0.35, 0.9, 0.45)
		"ORANGE": allocation_feedback_label.modulate = Color(1.0, 0.65, 0.2)
		_: allocation_feedback_label.modulate = Color(1.0, 0.3, 0.3)

func _update_operation_ui(operation: ProductionOperation, status_label: Label, unlock_button: Button, level_up_button: Button, build_new_button: Button, unlock_requirement: String, can_unlock: bool) -> void:
	if not operation.unlocked:
		status_label.text = "%s — LOCKED (%s)" % [operation.display_name, unlock_requirement]
		unlock_button.visible = true
		unlock_button.text = "UNLOCK %s (%s Materials)" % [operation.display_name.to_upper(), NumberFormatter.format_number(operation.unlock_cost())]
		unlock_button.disabled = not can_unlock
		level_up_button.visible = false
		build_new_button.visible = false
		return

	status_label.text = "%s — Level %d | Buildings %d | Milestone ×%s" % [operation.display_name, operation.level, operation.count, NumberFormatter.format_number(operation.milestone_multiplier())]
	unlock_button.visible = false
	level_up_button.visible = true
	level_up_button.text = "LEVEL UP (%s Materials%s)" % [NumberFormatter.format_number(operation.level_up_cost()), " + %.1f Energy" % operation.level_up_energy_cost if operation.level_up_energy_cost > 0.0 else ""]
	level_up_button.disabled = GameState.data.materials.is_less_than(operation.level_up_cost()) or GameState.data.energy < operation.level_up_energy_cost
	build_new_button.visible = true
	build_new_button.text = "BUILD NEW (%s Materials%s)" % [NumberFormatter.format_number(operation.build_new_cost()), " + %.1f Energy" % operation.build_new_energy_cost if operation.build_new_energy_cost > 0.0 else ""]
	build_new_button.disabled = not operation.can_build_new(GameState.data.materials, GameState.data.energy)
