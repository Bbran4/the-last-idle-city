extends Node2D

const WORLD_SCALE := 0.40
const INTERACTION_RADIUS := 260.0
const RANGE_X := 1900.0
const MAP_X := -300.0
const TENT_X := -1000.0
const FLETCHER_X := 850.0
const CAMERA_SMOOTHING := 8.0

@onready var player: Player = $Player
var camera_base_x := 0.0
var status_label: Label
var map_panel: PanelContainer
var equipment_panel: PanelContainer
var stats: Node = Stats
var economy: Node = Economy
var bow_inventory := BowInventory.new()

func _ready() -> void:
	scale = Vector2.ONE * WORLD_SCALE
	_build_ui()

func _process(delta: float) -> void:
	var target_x := get_viewport_rect().size.x * 0.5 - player.position.x * WORLD_SCALE
	camera_base_x = lerp(camera_base_x, target_x, 1.0 - exp(-CAMERA_SMOOTHING * delta))
	position.x = camera_base_x
	_update_prompt()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE:
			_close_panels()
		elif event.keycode == KEY_E:
			_interact()
		elif event.keycode == KEY_R:
			player.position = Vector2(0.0, player.GROUND_Y)

func _interact() -> void:
	var x := player.position.x
	if abs(x - RANGE_X) <= INTERACTION_RADIUS:
		get_tree().change_scene_to_file("res://scenes/practice.tscn")
	elif abs(x - MAP_X) <= INTERACTION_RADIUS:
		map_panel.visible = true
		player.set_process_mode(Node.PROCESS_MODE_DISABLED)
	elif abs(x - TENT_X) <= INTERACTION_RADIUS:
		equipment_panel.visible = true
		_refresh_equipment()
		player.set_process_mode(Node.PROCESS_MODE_DISABLED)
	elif abs(x - FLETCHER_X) <= INTERACTION_RADIUS:
		status_label.text = "FLETCHER: BOWS AND CRAFTING WILL LIVE HERE"
		status_label.visible = true

func _update_prompt() -> void:
	if map_panel.visible or equipment_panel.visible:
		return
	var x := player.position.x
	var prompt := ""
	if abs(x - RANGE_X) <= INTERACTION_RADIUS:
		prompt = "E  ENTER ARCHERY RANGE"
	elif abs(x - MAP_X) <= INTERACTION_RADIUS:
		prompt = "E  OPEN KINGDOM MAP"
	elif abs(x - TENT_X) <= INTERACTION_RADIUS:
		prompt = "E  OPEN EQUIPMENT"
	elif abs(x - FLETCHER_X) <= INTERACTION_RADIUS:
		prompt = "E  TALK TO FLETCHER"
	status_label.text = prompt
	status_label.visible = not prompt.is_empty()

func _build_ui() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)
	var title := Label.new()
	title.position = Vector2(24, 18)
	title.text = "THE LAST ARCHER"
	title.add_theme_font_size_override("font_size", 28)
	layer.add_child(title)
	var subtitle := Label.new()
	subtitle.position = Vector2(26, 53)
	subtitle.text = "THE TRAINING SETTLEMENT"
	layer.add_child(subtitle)
	status_label = Label.new()
	status_label.position = Vector2(0, 650)
	status_label.size = Vector2(1280, 40)
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.visible = false
	layer.add_child(status_label)
	map_panel = _panel("KINGDOM MAP", ["GREENFIELD", "BLACKWOOD", "EASTMERE", "KING'S CITY", "COASTAL PORT"])
	equipment_panel = PanelContainer.new()
	equipment_panel.position = Vector2(30, 170)
	equipment_panel.size = Vector2(360, 390)
	equipment_panel.visible = false
	layer.add_child(equipment_panel)

func _panel(title_text: String, destinations: Array) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.position = Vector2(250, 80)
	panel.size = Vector2(780, 560)
	panel.visible = false
	$"/root".add_child(panel) if false else get_node(".").add_child(panel)
	var box := VBoxContainer.new()
	panel.add_child(box)
	var title := Label.new()
	title.text = title_text
	title.add_theme_font_size_override("font_size", 28)
	box.add_child(title)
	for destination in destinations:
		var button := Button.new()
		button.text = destination
		button.pressed.connect(_travel_to.bind(destination))
		box.add_child(button)
	var close := Button.new()
	close.text = "CLOSE"
	close.pressed.connect(_close_panels)
	box.add_child(close)
	return panel

func _refresh_equipment() -> void:
	for child in equipment_panel.get_children():
		child.queue_free()
	var box := VBoxContainer.new()
	equipment_panel.add_child(box)
	var title := Label.new()
	title.text = "EQUIPMENT TENT"
	box.add_child(title)
	var info := Label.new()
	info.text = "STRENGTH %d    ACCURACY %d\nCOINS %d" % [stats.strength_level, stats.accuracy_level, economy.money]
	box.add_child(info)
	for bow: BowData in bow_inventory.get_all_bows():
		var button := Button.new()
		button.text = "%s  %s" % [bow.display_name, "[EQUIPPED]" if bow.id == bow_inventory.equipped_bow_id else "[EQUIP]"]
		button.disabled = bow.id == bow_inventory.equipped_bow_id
		button.pressed.connect(_equip_bow.bind(bow.id))
		box.add_child(button)
	var close := Button.new()
	close.text = "CLOSE"
	close.pressed.connect(_close_panels)
	box.add_child(close)

func _equip_bow(bow_id: String) -> void:
	if bow_inventory.equip(bow_id, stats.strength_level):
		_refresh_equipment()

func _travel_to(destination: String) -> void:
	TravelState.destination = destination
	get_tree().change_scene_to_file("res://scenes/travel_location.tscn")

func _close_panels() -> void:
	map_panel.visible = false
	equipment_panel.visible = false
	player.set_process_mode(Node.PROCESS_MODE_INHERIT)
