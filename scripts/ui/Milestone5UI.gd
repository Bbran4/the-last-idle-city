extends Node

var panel: VBoxContainer
var energy_label: Label
var souls_label: Label
var department_label: Label
var priority_label: Label
var initialized := false


func _process(_delta: float) -> void:
	if not initialized:
		_try_initialize()
		return
	_update_ui()


func _try_initialize() -> void:
	var scene := get_tree().current_scene
	if scene == null:
		return
	var rail := scene.get_node_or_null("Layout/VBox/Body/RightRail/VBox")
	if rail == null:
		return

	panel = VBoxContainer.new()
	panel.name = "Milestone5Panel"
	panel.add_theme_constant_override("separation", 4)
	rail.add_child(panel)

	var header := Label.new()
	header.text = "ENERGY & GOVERNMENT"
	panel.add_child(header)

	energy_label = Label.new()
	panel.add_child(energy_label)

	souls_label = Label.new()
	panel.add_child(souls_label)

	department_label = Label.new()
	department_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	panel.add_child(department_label)

	priority_label = Label.new()
	panel.add_child(priority_label)

	var priority_row := HBoxContainer.new()
	panel.add_child(priority_row)
	for priority in ["Industrial", "Civilian", "Security", "Scientific"]:
		var button := Button.new()
		button.text = priority.substr(0, 4)
		button.tooltip_text = "Set %s as the protected Energy priority" % priority
		button.pressed.connect(_set_priority.bind(priority))
		priority_row.add_child(button)

	initialized = true
	_update_ui()


func _set_priority(priority: String) -> void:
	GameState.data.set_energy_priority(priority)
	_update_ui()


func _update_ui() -> void:
	if panel == null:
		return
	var data := GameState.data
	var state := data.energy_shortage_state()
	energy_label.text = "Energy: %.1f | %.2f/sec | use %.2f/sec | %s" % [
		data.energy,
		data.energy_production_per_second(),
		data.energy_consumption_per_second(),
		state
	]
	souls_label.text = "Souls: %.1f (+%.1f/sec)" % [data.souls, GameData.SOULS_PER_SECOND]
	department_label.text = "Government workforce: Industrial %.0f%% | Civilian %.0f%% | Security %.0f%% | Scientific %.0f%%" % [
		data.industrial_allocation_percent,
		data.civilian_allocation_percent,
		data.security_allocation_percent,
		data.scientific_allocation_percent
	]
	priority_label.text = "Energy priority: %s | Production load-shed multiplier: ×%.2f" % [data.energy_priority, data.energy_production_multiplier()]
