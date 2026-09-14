extends Control

@onready var materials_label: Label = $Layout/VBox/Body/RightRail/VBox/MaterialsLabel
@onready var production_label: Label = $Layout/VBox/Body/Center/CityOverview/VBox/ProductionLabel
@onready var workforce_label: Label = $Layout/VBox/Body/RightRail/VBox/WorkforceLabel
@onready var chain_status_label: Label = $Layout/VBox/Body/RightRail/VBox/ChainStatusLabel
@onready var production_stats_label: Label = $Layout/VBox/Body/RightRail/VBox/ProductionStatsLabel
@onready var reclamation_depot_card: Control = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/ReclamationCard
@onready var reclamation_depot_label: Label = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/ReclamationCard/VBox/ReclamationDepotLabel
@onready var reclamation_depot_unlock_button: Button = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/ReclamationCard/VBox/ReclamationDepotUnlockButton
@onready var reclamation_depot_level_up_button: Button = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/ReclamationCard/VBox/ReclamationDepotLevelUpButton
@onready var reclamation_depot_build_new_button: Button = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/ReclamationCard/VBox/ReclamationDepotBuildNewButton
@onready var workshop_card: Control = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/WorkshopCard
@onready var workshop_label: Label = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/WorkshopCard/VBox/WorkshopLabel
@onready var workshop_unlock_button: Button = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/WorkshopCard/VBox/WorkshopUnlockButton
@onready var workshop_level_up_button: Button = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/WorkshopCard/VBox/WorkshopLevelUpButton
@onready var workshop_build_new_button: Button = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/WorkshopCard/VBox/WorkshopBuildNewButton
@onready var factory_card: Control = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/FactoryCard
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
@onready var top_materials_label: Label = $Layout/VBox/TopBar/HBox/TopMaterialsLabel
@onready var top_production_label: Label = $Layout/VBox/TopBar/HBox/TopProductionLabel

var scrap_yard_milestone_button: Button
var reclamation_depot_milestone_button: Button
var workshop_milestone_button: Button
var factory_milestone_button: Button
var production_feedback_tween: Tween

func _ready() -> void:
	$Layout.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	$Layout/VBox/Body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	$Layout/VBox/Body/Center/WorkforcePanel.visible = false
	workforce_label.visible = false
	manual_production_button.visible = false
	reclamation_depot_card.visible = false
	workshop_card.visible = false
	factory_card.visible = false
	_create_milestone_button($Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/ScrapCard/VBox, "ScrapYardMilestoneButton", func(): return GameState.data.scrap_yard)
	_create_milestone_button($Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/ReclamationCard/VBox, "ReclamationDepotMilestoneButton", func(): return GameState.data.reclamation_depot)
	_create_milestone_button($Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/WorkshopCard/VBox, "WorkshopMilestoneButton", func(): return GameState.data.workshop)
	_create_milestone_button($Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/FactoryCard/VBox, "FactoryMilestoneButton", func(): return GameState.data.factory)
	scrap_yard_milestone_button = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/ScrapCard/VBox/ScrapYardMilestoneButton
	reclamation_depot_milestone_button = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/ReclamationCard/VBox/ReclamationDepotMilestoneButton
	workshop_milestone_button = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/WorkshopCard/VBox/WorkshopMilestoneButton
	factory_milestone_button = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/FactoryCard/VBox/FactoryMilestoneButton
	game_clock.tick.connect(_on_game_tick)
	save_button.pressed.connect(_on_save_pressed)
	load_button.pressed.connect(_on_load_pressed)
	level_up_button.pressed.connect(_on_level_up_pressed)
	build_new_button.pressed.connect(_on_build_new_pressed)
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

func _create_milestone_button(card: VBoxContainer, button_name: String, operation_getter: Callable) -> void:
	var button: Button = Button.new()
	button.name = button_name
	button.text = "MILESTONE"
	button.pressed.connect(func():
		var operation: ProductionOperation = operation_getter.call()
		if GameState.data.trigger_operation_milestone(operation):
			_update_ui()
	)
	card.add_child(button)

func _on_game_tick(_delta: float) -> void:
	_update_ui()

func _update_ui() -> void:
	var data: GameData = GameState.data
	materials_label.text = "Materials: %s" % NumberFormatter.format_number(data.materials)
	top_materials_label.text = "Materials: %s" % NumberFormatter.format_number(data.materials)
	production_label.text = "Scrap Yard production: %s Materials/sec" % NumberFormatter.format_number(data.scrap_yard_production_per_second())
	top_production_label.text = "Production: %s/sec" % NumberFormatter.format_number(data.scrap_yard_production_per_second())
	chain_status_label.text = "Factory: %s Workshops/sec  →  Workshop: %s Depots/sec  →  Depot: %s Scrap Yards/sec" % [NumberFormatter.format_rate(data.factory_workshop_rate()), NumberFormatter.format_rate(data.workshop_reclamation_depot_rate()), NumberFormatter.format_rate(data.reclamation_depot_scrap_yard_rate())]
	production_stats_label.text = "Lifetime Materials: %s | Energy: %.1f (+%.1f/sec)" % [NumberFormatter.format_number(data.total_materials_produced), data.energy, data.energy_production_per_second()]
	tick_label.text = "Game Time: %.0fs | Ticks: %d" % [data.game_time, data.total_ticks]

	scrap_yard_level_label.text = "Scrap Yard level: %d" % data.scrap_yard.level
	scrap_yard_count_label.text = "Scrap Yards: %d" % data.scrap_yard.count
	level_up_button.text = "LEVEL UP (%s Materials + %.1f Energy)" % [NumberFormatter.format_number(data.scrap_yard_level_up_cost()), data.scrap_yard.level_up_energy_cost]
	level_up_button.disabled = not data.can_level_up_scrap_yard()
	build_new_button.text = "BUILD SCRAP YARD (%s Materials + %.1f Energy)" % [NumberFormatter.format_number(data.scrap_yard_build_new_cost()), data.scrap_yard.build_new_energy_cost]
	build_new_button.visible = data.can_build_new_scrap_yard()
	_update_scrap_yard_milestone_ui(data)

	_update_operation_ui(data.reclamation_depot, reclamation_depot_label, reclamation_depot_unlock_button, reclamation_depot_level_up_button, reclamation_depot_build_new_button, data.can_unlock_reclamation_depot(), reclamation_depot_milestone_button)
	_update_operation_ui(data.workshop, workshop_label, workshop_unlock_button, workshop_level_up_button, workshop_build_new_button, data.can_unlock_workshop(), workshop_milestone_button)
	_update_operation_ui(data.factory, factory_label, factory_unlock_button, factory_level_up_button, factory_build_new_button, data.can_unlock_factory(), factory_milestone_button)

func _update_scrap_yard_milestone_ui(data: GameData) -> void:
	var can_trigger: bool = data.can_trigger_scrap_yard_milestone()
	var next_level: int = data.scrap_yard_next_milestone_level()
	var next_energy: float = data.scrap_yard_next_milestone_energy_cost()

	if can_trigger:
		milestone_label.visible = false
		scrap_yard_milestone_button.visible = true
		scrap_yard_milestone_button.text = "MILESTONE (Level %d + %.1f Energy)" % [next_level, next_energy]
		scrap_yard_milestone_button.disabled = false
		return

	scrap_yard_milestone_button.visible = false
	if data.scrap_yard.milestones_triggered > 0:
		milestone_label.visible = true
		milestone_label.text = "Next milestone: level %d" % next_level
	else:
		milestone_label.visible = false

func _update_milestone_button(operation: ProductionOperation, button: Button) -> void:
	button.text = "MILESTONE (Level %d + %.1f Energy)" % [operation.next_milestone_level(), operation.next_milestone_energy_cost()]
	button.disabled = not operation.can_trigger_milestone(GameState.data.energy)
	button.visible = operation.unlocked

func _update_operation_ui(operation: ProductionOperation, status_label: Label, unlock_button: Button, level_up_button_ref: Button, build_new_button_ref: Button, can_unlock: bool, milestone_button: Button) -> void:
	if not operation.unlocked:
		status_label.text = "%s — LOCKED" % operation.display_name
		unlock_button.visible = false
		level_up_button_ref.visible = false
		build_new_button_ref.visible = false
		milestone_button.visible = false
		return

	status_label.text = "%s — Level %d | Buildings %d | Milestone ×%s" % [operation.display_name, operation.level, operation.count, NumberFormatter.format_number(operation.milestone_multiplier())]
	unlock_button.visible = false
	level_up_button_ref.visible = true
	level_up_button_ref.text = "LEVEL UP (%s Materials + %.1f Energy)" % [NumberFormatter.format_number(operation.level_up_cost()), operation.level_up_energy_cost]
	level_up_button_ref.disabled = GameState.data.materials.is_less_than(operation.level_up_cost()) or GameState.data.energy < operation.level_up_energy_cost
	build_new_button_ref.visible = operation.can_build_new(GameState.data.materials, GameState.data.energy)
	build_new_button_ref.text = "BUILD NEW (%s Materials + %.1f Energy)" % [NumberFormatter.format_number(operation.build_new_cost()), operation.build_new_energy_cost]
	_update_milestone_button(operation, milestone_button)

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

func _on_reclamation_depot_unlock_pressed() -> void:
	if GameState.data.unlock_operation(GameState.data.reclamation_depot):
		_update_ui()

func _on_reclamation_depot_level_up_pressed() -> void:
	if GameState.data.level_up_reclamation_depot():
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
