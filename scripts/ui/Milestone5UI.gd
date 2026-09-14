extends Node

var panel: VBoxContainer
var energy_label: Label
var department_label: Label
var priority_label: Label
var production_label: Label
var initialized: bool = false

func _process(_delta: float) -> void:
	if not initialized:
		_try_initialize()
		return
	_update_ui()

func _try_initialize() -> void:
	var scene: Node = get_tree().current_scene
	if scene == null:
		return
	var rail: Node = scene.get_node_or_null("Layout/VBox/Body/RightRail/VBox")
	if rail == null:
		return

	panel = VBoxContainer.new()
	panel.name = "Milestone5Panel"
	panel.add_theme_constant_override("separation", 4)
	rail.add_child(panel)

	var header: Label = Label.new()
	header.text = "ENERGY & GOVERNMENT"
	panel.add_child(header)

	energy_label = Label.new()
	panel.add_child(energy_label)

	production_label = Label.new()
	production_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	panel.add_child(production_label)

	department_label = Label.new()
	department_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	panel.add_child(department_label)

	for department: String in ["Industrial", "Civilian", "Security", "Scientific"]:
		var row: HBoxContainer = HBoxContainer.new()
		panel.add_child(row)
		var label: Label = Label.new()
		label.name = "%sLabel" % department
		label.custom_minimum_size.x = 110.0
		row.add_child(label)
		var minus: Button = Button.new()
		minus.text = "-5"
		minus.pressed.connect(_adjust_department.bind(department, -5.0))
		row.add_child(minus)
		var plus: Button = Button.new()
		plus.text = "+5"
		plus.pressed.connect(_adjust_department.bind(department, 5.0))
		row.add_child(plus)

	priority_label = Label.new()
	panel.add_child(priority_label)

	var priority_row: HBoxContainer = HBoxContainer.new()
	panel.add_child(priority_row)
	for priority: String in ["Industrial", "Civilian", "Security", "Scientific"]:
		var button: Button = Button.new()
		button.text = priority.substr(0, 4)
		button.tooltip_text = "Protect %s during Energy shortages" % priority
		button.pressed.connect(_set_priority.bind(priority))
		priority_row.add_child(button)

	var milestone_header: Label = Label.new()
	milestone_header.text = "PRODUCTION MILESTONES"
	panel.add_child(milestone_header)

	for operation_name: String in ["Reclamation Depot", "Workshop", "Factory"]:
		var row: HBoxContainer = HBoxContainer.new()
		panel.add_child(row)
		var label: Label = Label.new()
		label.name = "%sMilestoneLabel" % operation_name.replace(" ", "")
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(label)
		var button: Button = Button.new()
		button.name = "%sMilestoneButton" % operation_name.replace(" ", "")
		button.text = "MILESTONE"
		button.pressed.connect(_trigger_milestone.bind(operation_name))
		row.add_child(button)

	initialized = true
	_update_ui()

func _set_priority(priority: String) -> void:
	GameState.data.set_energy_priority(priority)
	_update_ui()

func _adjust_department(department: String, amount: float) -> void:
	var current: float = GameState.data.get_department_allocation(department)
	GameState.data.set_department_allocation(department, current + amount)
	_update_ui()

func _trigger_milestone(operation_name: String) -> void:
	var operation: ProductionOperation = _get_operation(operation_name)
	if operation == null:
		return
	GameState.data.trigger_operation_milestone(operation)
	_update_ui()

func _get_operation(operation_name: String) -> ProductionOperation:
	match operation_name:
		"Scrap Yard": return GameState.data.scrap_yard
		"Reclamation Depot": return GameState.data.reclamation_depot
		"Workshop": return GameState.data.workshop
		"Factory": return GameState.data.factory
	return null

func _update_ui() -> void:
	if panel == null:
		return
	var data: GameData = GameState.data
	energy_label.text = "Energy: %.1f | +%.2f/sec | -%.2f/sec | Balance %.2f/sec | %s" % [data.energy, data.energy_production_per_second(), data.energy_consumption_per_second(), data.energy_balance_per_second(), data.energy_shortage_state()]
	production_label.text = "Scrap Yard: %d yards | level %d | production %s/sec" % [data.scrap_yard.count, data.scrap_yard.level, NumberFormatter.format_number(data.scrap_yard_production_per_second())]
	department_label.text = "Government workforce: %.0f%% Industrial | %.0f%% Civilian | %.0f%% Security | %.0f%% Scientific" % [data.industrial_allocation_percent, data.civilian_allocation_percent, data.security_allocation_percent, data.scientific_allocation_percent]
	priority_label.text = "Energy priority: %s | Load-shed output multiplier: ×%.2f" % [data.energy_priority, data.energy_production_multiplier()]

	for department: String in ["Industrial", "Civilian", "Security", "Scientific"]:
		var label: Label = panel.get_node_or_null("%sLabel" % department)
		if label != null:
			label.text = "%s: %.0f%%" % [department, data.get_department_allocation(department)]

	_update_milestone_row("ReclamationDepot", data.reclamation_depot)
	_update_milestone_row("Workshop", data.workshop)
	_update_milestone_row("Factory", data.factory)

func _update_milestone_row(node_name: String, operation: ProductionOperation) -> void:
	var label: Label = panel.get_node_or_null("%sMilestoneLabel" % node_name)
	var button: Button = panel.get_node_or_null("%sMilestoneButton" % node_name)
	if label == null or button == null:
		return
	if not operation.unlocked:
		label.text = "%s: LOCKED" % operation.display_name
		button.disabled = true
		return
	label.text = "%s: ×%s | next level %d | %.1f Energy" % [operation.display_name, NumberFormatter.format_number(operation.milestone_multiplier()), operation.next_milestone_level(), operation.next_milestone_energy_cost()]
	button.disabled = not operation.can_trigger_milestone(GameState.data.energy)
