extends Control

@onready var materials_label: Label = $Layout/VBox/Body/RightRail/VBox/MaterialsLabel
@onready var production_label: Label = $Layout/VBox/Body/Center/CityOverview/VBox/ProductionLabel
@onready var workforce_label: Label = $Layout/VBox/Body/RightRail/VBox/WorkforceLabel
@onready var chain_status_label: Label = $Layout/VBox/Body/RightRail/VBox/ChainStatusLabel
@onready var production_stats_label: Label = $Layout/VBox/Body/RightRail/VBox/ProductionStatsLabel
@onready var population_label: Label = $Layout/VBox/Body/RightRail/VBox/PopulationLabel
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
@onready var top_population_label: Label = $Layout/VBox/TopBar/HBox/TopPopulationLabel

# Workforce/allocation panel (Milestone 3 - now wired to real GameData
# instead of being static mockup text).
@onready var workforce_panel: Control = $Layout/VBox/Body/Center/WorkforcePanel
@onready var industrial_allocation_label: Label = $Layout/VBox/Body/Center/WorkforcePanel/VBox/IndustrialAllocationLabel
@onready var industrial_allocation_slider: HSlider = $Layout/VBox/Body/Center/WorkforcePanel/VBox/IndustrialAllocationSlider
@onready var allocation_feedback_label: Label = $Layout/VBox/Body/Center/WorkforcePanel/VBox/AllocationFeedbackLabel

# Materials-chain cards container (existing "Cards" HBoxContainer).
@onready var materials_cards_container: HBoxContainer = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards
@onready var card_scroll: ScrollContainer = $Layout/VBox/OperationsPanel/VBox/CardScroll
@onready var operations_panel_vbox: VBoxContainer = $Layout/VBox/OperationsPanel/VBox
@onready var rightrail_vbox: VBoxContainer = $Layout/VBox/Body/RightRail/VBox
@onready var rightrail_header: Label = $Layout/VBox/Body/RightRail/VBox/Header

var scrap_yard_milestone_button: Button
var reclamation_depot_milestone_button: Button
var workshop_milestone_button: Button
var factory_milestone_button: Button
var scrap_yard_production_rate_label: Label
var level_up_mode_container: HBoxContainer
var level_up_mode: String = "x1"
var production_feedback_tween: Tween

# --- Energy chain (new) ---
var energy_cards_container: HBoxContainer
var generator_level_label: Label
var generator_count_label: Label
var generator_milestone_label: Label
var generator_level_up_button: Button
var generator_build_new_button: Button
var generator_milestone_button: Button
var energy_stats_label: Label

# --- Materials/Energy chain tab switch (OperationsPanel + RightRail) ---
var selected_chain: String = "materials"
var operations_materials_button: Button
var operations_energy_button: Button
var rightrail_materials_button: Button
var rightrail_energy_button: Button

func _ready() -> void:
	$Layout.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	$Layout/VBox/Body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	workforce_label.visible = true
	workforce_panel.visible = true
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

	_create_energy_chain_ui()
	_create_chain_tab_bars()

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
	industrial_allocation_slider.value_changed.connect(_on_industrial_allocation_changed)

	_update_chain_visibility()
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

## Builds the Energy chain's OperationsPanel card (Generator) and the
## RightRail's Energy stats readout. Built at runtime, reusing the
## existing card/button stylebox resources from the Scrap Yard card so
## it matches the rest of the UI without needing scene edits.
func _create_energy_chain_ui() -> void:
	energy_cards_container = HBoxContainer.new()
	energy_cards_container.name = "EnergyCards"
	energy_cards_container.add_theme_constant_override("separation", 10)
	energy_cards_container.visible = false
	card_scroll.add_child(energy_cards_container)

	var scrap_card: PanelContainer = $Layout/VBox/OperationsPanel/VBox/CardScroll/Cards/ScrapCard
	var panel_style: StyleBox = scrap_card.get_theme_stylebox("panel")
	var normal_style: StyleBox = level_up_button.get_theme_stylebox("normal")
	var disabled_style: StyleBox = level_up_button.get_theme_stylebox("disabled")

	var card := PanelContainer.new()
	card.name = "GeneratorCard"
	card.custom_minimum_size = Vector2(240, 0)
	if panel_style != null:
		card.add_theme_stylebox_override("panel", panel_style)

	var vbox := VBoxContainer.new()
	card.add_child(vbox)

	var title := Label.new()
	title.text = "GENERATOR"
	vbox.add_child(title)

	generator_level_label = Label.new()
	vbox.add_child(generator_level_label)

	generator_count_label = Label.new()
	vbox.add_child(generator_count_label)

	generator_milestone_label = Label.new()
	generator_milestone_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(generator_milestone_label)

	generator_level_up_button = Button.new()
	generator_level_up_button.text = "LEVEL UP"
	if normal_style != null:
		generator_level_up_button.add_theme_stylebox_override("normal", normal_style)
	if disabled_style != null:
		generator_level_up_button.add_theme_stylebox_override("disabled", disabled_style)
	generator_level_up_button.pressed.connect(_on_generator_level_up_pressed)
	vbox.add_child(generator_level_up_button)

	generator_build_new_button = Button.new()
	generator_build_new_button.text = "BUILD NEW"
	if normal_style != null:
		generator_build_new_button.add_theme_stylebox_override("normal", normal_style)
	if disabled_style != null:
		generator_build_new_button.add_theme_stylebox_override("disabled", disabled_style)
	generator_build_new_button.pressed.connect(_on_generator_build_new_pressed)
	vbox.add_child(generator_build_new_button)

	energy_cards_container.add_child(card)

	_create_milestone_button(vbox, "GeneratorMilestoneButton", func(): return GameState.data.generator)
	generator_milestone_button = vbox.get_node("GeneratorMilestoneButton")

	# RightRail Energy readout, inserted right after the Materials chain
	# status label so the two chains occupy the same visual slot.
	energy_stats_label = Label.new()
	energy_stats_label.name = "EnergyStatsLabel"
	energy_stats_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	energy_stats_label.visible = false
	rightrail_vbox.add_child(energy_stats_label)
	rightrail_vbox.move_child(energy_stats_label, chain_status_label.get_index() + 1)

## Adds a small "MATERIALS / ENERGY" tab bar to both the OperationsPanel
## and the RightRail. The two bars stay in sync through _set_selected_chain
## so switching either one switches both, similar to the reference UI.
func _create_chain_tab_bars() -> void:
	var operations_buttons := _create_chain_tab_bar(operations_panel_vbox, card_scroll)
	operations_materials_button = operations_buttons["materials"]
	operations_energy_button = operations_buttons["energy"]

	var rightrail_buttons := _create_chain_tab_bar(rightrail_vbox, rightrail_header)
	rightrail_materials_button = rightrail_buttons["materials"]
	rightrail_energy_button = rightrail_buttons["energy"]

func _create_chain_tab_bar(parent: Control, insert_before: Node) -> Dictionary:
	var container := HBoxContainer.new()
	container.name = "ChainTabs"
	container.add_theme_constant_override("separation", 4)

	var group := ButtonGroup.new()

	var materials_button := Button.new()
	materials_button.text = "MATERIALS"
	materials_button.toggle_mode = true
	materials_button.button_group = group
	materials_button.button_pressed = selected_chain == "materials"
	materials_button.pressed.connect(func(): _set_selected_chain("materials"))
	container.add_child(materials_button)

	var energy_button := Button.new()
	energy_button.text = "ENERGY"
	energy_button.toggle_mode = true
	energy_button.button_group = group
	energy_button.button_pressed = selected_chain == "energy"
	energy_button.pressed.connect(func(): _set_selected_chain("energy"))
	container.add_child(energy_button)

	parent.add_child(container)
	parent.move_child(container, insert_before.get_index())

	return {"materials": materials_button, "energy": energy_button}

func _set_selected_chain(chain: String) -> void:
	selected_chain = chain
	operations_materials_button.button_pressed = chain == "materials"
	operations_energy_button.button_pressed = chain == "energy"
	rightrail_materials_button.button_pressed = chain == "materials"
	rightrail_energy_button.button_pressed = chain == "energy"
	_update_chain_visibility()
	_update_ui()

func _update_chain_visibility() -> void:
	var showing_materials: bool = selected_chain == "materials"
	materials_cards_container.visible = showing_materials
	energy_cards_container.visible = not showing_materials
	chain_status_label.visible = showing_materials
	energy_stats_label.visible = not showing_materials

func _on_game_tick(_delta: float) -> void:
	_update_ui()

func _update_ui() -> void:
	var data: GameData = GameState.data
	materials_label.text = "Materials: %s" % NumberFormatter.format_number(data.materials)
	top_materials_label.text = "Materials: %s" % NumberFormatter.format_number(data.materials)
	production_label.text = "Scrap Yard production: %s Materials/sec" % NumberFormatter.format_number(data.scrap_yard_production_per_second())
	top_production_label.text = "Production: %s/sec" % NumberFormatter.format_number(data.scrap_yard_production_per_second())
	chain_status_label.text = "Factory: %s Workshops/sec  →  Workshop: %s Depots/sec  →  Depot: %s Scrap Yards/sec" % [NumberFormatter.format_rate(data.factory_workshop_rate()), NumberFormatter.format_rate(data.workshop_reclamation_depot_rate()), NumberFormatter.format_rate(data.reclamation_depot_scrap_yard_rate())]
	production_stats_label.text = "Lifetime Materials: %s | Energy: %.1f (+%.1f/sec)" % [NumberFormatter.format_number(data.total_materials_produced), data.energy, data.energy_balance_per_second()]
	tick_label.text = "Game Time: %.0fs | Ticks: %d" % [data.game_time, data.total_ticks]

	top_population_label.text = "POPULATION\n%d  +%.1f/sec" % [int(data.population), GameData.POPULATION_GROWTH_PER_SECOND]
	population_label.text = "Population: %d (+%.1f/sec)" % [int(data.population), GameData.POPULATION_GROWTH_PER_SECOND]
	workforce_label.text = "Available workforce: %d | Industrial: %d | Central Gov: %d" % [int(data.available_workforce()), int(data.industrial_authority_workforce()), int(data.central_government_workforce())]

	industrial_allocation_label.text = "Industrial Authority allocation: %d%%" % int(round(data.industrial_authority_allocation))
	var zone: String = data.allocation_zone_name(data.industrial_authority_allocation)
	allocation_feedback_label.text = "%s allocation efficiency: %d%% | Efficient range: %d%%–%d%% | Scrap Yard: ×%.2f" % [
		zone,
		int(round(data.industrial_authority_efficiency() * 100.0)),
		int(GameData.ALLOCATION_EFFICIENT_MIN),
		int(GameData.ALLOCATION_EFFICIENT_MAX),
		data.industrial_authority_efficiency()
	]
	allocation_feedback_label.modulate = _zone_color(zone)

	energy_stats_label.text = "Generator: %s Energy/s | Consumption: %.2f/s | Supply met: %d%%%s" % [
		NumberFormatter.format_number(data.generator_production_per_second()),
		data.energy_consumption_per_second(),
		int(round(data.power_supply_ratio() * 100.0)),
		"  (LOAD SHEDDING)" if data.is_energy_shortage() else ""
	]

	_update_scrap_yard_ui(data)
	_update_generator_ui(data)
	_update_operation_ui(data.reclamation_depot, reclamation_depot_label, reclamation_depot_unlock_button, reclamation_depot_level_up_button, reclamation_depot_build_new_button, data.can_unlock_reclamation_depot(), reclamation_depot_milestone_button)
	_update_operation_ui(data.workshop, workshop_label, workshop_unlock_button, workshop_level_up_button, workshop_build_new_button, data.can_unlock_workshop(), workshop_milestone_button)
	_update_operation_ui(data.factory, factory_label, factory_unlock_button, factory_level_up_button, factory_build_new_button, data.can_unlock_factory(), factory_milestone_button)

func _zone_color(zone: String) -> Color:
	match zone:
		"GREEN":
			return Color(0.35, 0.9, 0.45, 1)
		"ORANGE":
			return Color(0.95, 0.65, 0.25, 1)
		_:
			return Color(0.9, 0.3, 0.3, 1)

func _update_scrap_yard_ui(data: GameData) -> void:
	scrap_yard_level_label.text = "SCRAP YARD (%d)" % data.scrap_yard.count
	scrap_yard_count_label.text = "You have %d Scrap Yard level %d\nEach level produces %s Material/s\nAll produce %s Material/s" % [data.scrap_yard.count, data.scrap_yard.level, NumberFormatter.format_number(data.scrap_yard.milestone_multiplier()), NumberFormatter.format_number(data.scrap_yard_production_per_second())]
	scrap_yard_production_rate_label.text = "To create Scrap Yard you need:\nScrap Yard Level 25"
	level_up_button.text = "LEVEL UP (%s Materials + %.1f Energy)" % [NumberFormatter.format_number(data.scrap_yard_level_up_cost()), data.scrap_yard.level_up_energy_cost]
	level_up_button.disabled = not data.can_level_up_scrap_yard()
	build_new_button.text = "BUILD SCRAP YARD"
	build_new_button.visible = data.can_build_new_scrap_yard()
	_update_scrap_yard_milestone_ui(data)

func _update_generator_ui(data: GameData) -> void:
	generator_level_label.text = "Generator level: %d" % data.generator.level
	generator_count_label.text = "Generators: %d (×%s)" % [data.generator.count, NumberFormatter.format_number(data.generator.milestone_multiplier())]
	generator_milestone_label.text = _milestone_description(data.generator)
	generator_level_up_button.text = "LEVEL UP (%s Materials)" % NumberFormatter.format_number(data.generator_level_up_cost())
	generator_level_up_button.disabled = not data.can_level_up_generator()
	generator_build_new_button.text = "BUILD NEW (%s Materials)" % NumberFormatter.format_number(data.generator_build_new_cost())
	generator_build_new_button.visible = data.can_build_new_generator()
	generator_milestone_button.text = "UPGRADE"
	generator_milestone_button.disabled = not data.can_trigger_generator_milestone()
	generator_milestone_button.visible = data.generator.level >= data.generator_next_milestone_level()

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

func _on_generator_level_up_pressed() -> void:
	if GameState.data.level_up_generator():
		_update_ui()

func _on_generator_build_new_pressed() -> void:
	if GameState.data.build_new_generator():
		_update_ui()

func _on_industrial_allocation_changed(value: float) -> void:
	GameState.data.set_industrial_authority_allocation(value)
	_update_ui()
