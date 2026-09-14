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
@onready var scrap_yard_card_vbox: VBoxContainer = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/ScrapCard/VBox
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
var scrap_yard_production_rate_label: Label
var level_up_mode_container: HBoxContainer
var level_up_mode: String = "x1"
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
	_create_scrap_yard_production_rate_label()
	_create_level_up_mode_controls()
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

func _create_scrap_yard_production_rate_label() -> void:
	scrap_yard_production_rate_label = Label.new()
	scrap_yard_production_rate_label.name = "ScrapYardProductionRateLabel"
	scrap_yard_production_rate_label.text = ""
	scrap_yard_card_vbox.add_child(scrap_yard_production_rate_label)

func _create_level_up_mode_controls() -> void:
	level_up_mode_container = HBoxContainer.new()
	level_up_mode_container.name = "LevelUpModeControls"
	level_up_mode_container.add_theme_constant_override("separation", 4)
	level_up_mode_container.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	level_up_mode_container.position = Vector2(-230, 8)
	level_up_mode_container.size = Vector2(220, 36)
	$Layout/VBox/TopBar.add_child(level_up_mode_container)

	var button_group := ButtonGroup.new()
	_create_level_up_mode_button("Max", "max", button_group)
	_create_level_up_mode_button("Next", "next", button_group)
	_create_level_up_mode_button("x1", "x1", button_group)

func _create_level_up_mode_button(display_text: String, mode: String, button_group: ButtonGroup) -> void:
	var button := Button.new()
	button.text = display_text
	button.toggle_mode = true
	button.button_group = button_group
	button.custom_minimum_size = Vector2(65, 32)
	button.set_meta("level_up_mode", mode)
	button.pressed.connect(func():
		level_up_mode = str(button.get_meta("level_up_mode"))
	)
	if mode == level_up_mode:
		button.button_pressed = true
	level_up_mode_container.add_child(button)

func _create_milestone_button(card: VBoxContainer, button_name: String, operation_getter: Callable) -> void:
	var button: Button = Button.new()
	button.name = button_name
	button.text = "UPGRADE"
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

	_update_scrap_yard_ui(data)
	_update_operation_ui(data.reclamation_depot, reclamation_depot_label, reclamation_depot_unlock_button, reclamation_depot_level_up_button, reclamation_depot_build_new_button, data.can_unlock_reclamation_depot(), reclamation_depot_milestone_button)
	_update_operation_ui(data.workshop, workshop_label, workshop_unlock_button, workshop_level_up_button, workshop_build_new_button, data.can_unlock_workshop(), workshop_milestone_button)
	_update_operation_ui(data.factory, factory_label, factory_unlock_button, factory_level_up_button, factory_build_new_button, data.can_unlock_factory(), factory_milestone_button)

func _update_scrap_yard_ui(data: GameData) -> void:
	scrap_yard_level_label.text = "SCRAP YARD (%d)" % data.scrap_yard.count
	scrap_yard_count_label.text = "You have %d Scrap Yard level %d\nEach level produces %s Material/s\nAll produce %s Material/s" % [data.scrap_yard.count, data.scrap_yard.level, NumberFormatter.format_number(data.scrap_yard.milestone_multiplier()), NumberFormatter.format_number(data.scrap_yard_production_per_second())]
	scrap_yard_production_rate_label.text = "To create Scrap Yard you need:\nScrap Yard Level 25"
	level_up_button.text = "LEVEL UP (%s Materials + %.1f Energy)" % [NumberFormatter.format_number(data.scrap_yard_level_up_cost()), data.scrap_yard.level_up_energy_cost]
	level_up_button.disabled = not data.can_level_up_scrap_yard()
	build_new_button.text = "BUILD SCRAP YARD"
	build_new_button.visible = data.can_build_new_scrap_yard()
	_update_scrap_yard_milestone_ui(data)

func _milestone_description(operation: ProductionOperation) -> String:
	return "To upgrade %s you need %s Level %d\nEach doubles %s Production\nUpgrade x%d (Production x%s)" % [operation.display_name, operation.display_name, operation.next_milestone_level(), operation.display_name, operation.milestones_triggered, NumberFormatter.format_number(operation.milestone_multiplier())]

func _update_scrap_yard_milestone_ui(data: GameData) -> void:
	var next_level: int = data.scrap_yard_next_milestone_level()
	var reached_milestone: bool = data.scrap_yard.level >= next_level

	milestone_label.visible = true
	milestone_label.text = _milestone_description(data.scrap_yard)
	scrap_yard_milestone_button.visible = reached_milestone
	scrap_yard_milestone_button.text = "UPGRADE"
	scrap_yard_milestone_button.disabled = not data.can_trigger_scrap_yard_milestone()

func _operation_production_unit(operation: ProductionOperation) -> String:
	match operation.display_name:
		"Reclamation Depot":
			return "Scrap Yard levels/s"
		"Workshop":
			return "Reclamation Depots/s"
		"Factory":
			return "Workshops/s"
		_:
			return "units/s"

func _update_milestone_button(operation: ProductionOperation, button: Button) -> void:
	button.text = "UPGRADE"
	button.disabled = not operation.can_trigger_milestone()
	button.visible = operation.unlocked and operation.level >= operation.next_milestone_level()

func _update_operation_ui(operation: ProductionOperation, status_label: Label, unlock_button: Button, level_up_button_ref: Button, build_new_button_ref: Button, can_unlock: bool, milestone_button: Button) -> void:
	if not operation.unlocked:
		status_label.text = "%s — LOCKED" % operation.display_name
		unlock_button.visible = false
		level_up_button_ref.visible = false
		build_new_button_ref.visible = false
		milestone_button.visible = false
		return

	status_label.text = "%s (%d)\nYou have %d %s level %d\nEach level produces %s %s\nAll produce %s %s\n\nTo create %s you need:\n%s" % [
		operation.display_name.to_upper(),
		operation.count,
		operation.count,
		operation.display_name,
		operation.level,
		NumberFormatter.format_number(operation.milestone_multiplier()),
		_operation_production_unit(operation),
		NumberFormatter.format_number(operation.total_effectiveness()),
		_operation_production_unit(operation),
		operation.display_name,
		"the required level"
	]
	unlock_button.visible = false
	level_up_button_ref.visible = true
	level_up_button_ref.text = "LEVEL UP (%s Materials + %.1f Energy)" % [NumberFormatter.format_number(operation.level_up_cost()), operation.level_up_energy_cost]
	level_up_button_ref.disabled = GameState.data.materials.is_less_than(operation.level_up_cost()) or GameState.data.energy < operation.level_up_energy_cost
	build_new_button_ref.visible = operation.can_build_new(GameState.data.materials, GameState.data.energy)
	build_new_button_ref.text = "BUILD NEW"
	_update_milestone_button(operation, milestone_button)

func _on_save_pressed() -> void:
	SaveManager.save_game()

func _on_load_pressed() -> void:
	if SaveManager.load_game():
		_update_ui()

func _on_level_up_pressed() -> void:
	var data: GameData = GameState.data
	match level_up_mode:
		"x1":
			data.level_up_scrap_yard()
		"next":
			_level_up_scrap_yard_to_next_milestone()
		"max":
			_level_up_scrap_yard_max()
	_update_ui()

func _level_up_scrap_yard_to_next_milestone() -> void:
	var data: GameData = GameState.data
	var target_level: int = data.scrap_yard_next_milestone_level()
	var purchased: bool = false
	while data.scrap_yard.level < target_level and data.can_level_up_scrap_yard():
		if not data.level_up_scrap_yard():
			break
		purchased = true
	if not purchased:
		_level_up_scrap_yard_max()

func _level_up_scrap_yard_max() -> void:
	var data: GameData = GameState.data
	while data.can_level_up_scrap_yard():
		if not data.level_up_scrap_yard():
			break

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
