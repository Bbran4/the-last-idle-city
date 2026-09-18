extends Node2D

const WORLD_SCALE: float = 0.40
const INTERACTION_RADIUS: float = 260.0
const RANGE_X: float = 1900.0
const MAP_X: float = -300.0
const TENT_X: float = -1000.0
const FLETCHER_X: float = 850.0

@onready var player: Player = $Player

var map_open: bool = false
var equipment_open: bool = false
var status_timer: float = 0.0
var ui_layer: CanvasLayer
var map_panel: PanelContainer
var equipment_panel: PanelContainer
var status_label: Label

var stats: PlayerStats = PlayerStats.new()
var economy: PlayerEconomy = PlayerEconomy.new()
var bow_inventory: BowInventory = BowInventory.new()

func _ready() -> void:
	scale = Vector2.ONE * WORLD_SCALE
	_create_ui()
	queue_redraw()

func _process(delta: float) -> void:
	_update_camera()
	_update_interaction_prompt()
	if status_timer > 0.0:
		status_timer = max(status_timer - delta, 0.0)
		if status_timer <= 0.0 and not map_open and not equipment_open:
			status_label.visible = false
	queue_redraw()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE:
			if map_open or equipment_open:
				_close_all_panels()
			return
		if event.keycode == KEY_E:
			_handle_interaction()
			return
		if event.keycode == KEY_R:
			_reset_position()
			return

func _handle_interaction() -> void:
	var x: float = player.position.x
	if abs(x - RANGE_X) <= INTERACTION_RADIUS:
		get_tree().change_scene_to_file("res://scenes/practice.tscn")
		return
	if abs(x - MAP_X) <= INTERACTION_RADIUS:
		map_open = true
		equipment_open = false
		player.set_process_mode(Node.PROCESS_MODE_DISABLED)
		map_panel.visible = true
		return
	if abs(x - TENT_X) <= INTERACTION_RADIUS:
		equipment_open = true
		map_open = false
		player.set_process_mode(Node.PROCESS_MODE_DISABLED)
		equipment_panel.visible = true
		_refresh_equipment_panel()
		return
	if abs(x - FLETCHER_X) <= INTERACTION_RADIUS:
		_show_status("FLETCHER: BOWS AND CRAFTING WILL LIVE HERE")

func _update_camera() -> void:
	position.x = get_viewport_rect().size.x * 0.5 - player.position.x * WORLD_SCALE

func _update_interaction_prompt() -> void:
	if map_open or equipment_open:
		return
	var x: float = player.position.x
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

func _reset_position() -> void:
	player.position = Vector2(0.0, player.GROUND_Y)

func _show_status(text: String) -> void:
	status_label.text = text
	status_label.visible = true
	status_timer = 2.5

func _close_all_panels() -> void:
	map_open = false
	equipment_open = false
	map_panel.visible = false
	equipment_panel.visible = false
	player.set_process_mode(Node.PROCESS_MODE_INHERIT)

func _create_ui() -> void:
	ui_layer = CanvasLayer.new()
	add_child(ui_layer)

	status_label = Label.new()
	status_label.position = Vector2(0, 650)
	status_label.size = Vector2(1280, 40)
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.add_theme_font_size_override("font_size", 18)
	status_label.visible = false
	ui_layer.add_child(status_label)

	var title := Label.new()
	title.position = Vector2(24, 18)
	title.text = "THE LAST ARCHER"
	title.add_theme_font_size_override("font_size", 28)
	ui_layer.add_child(title)

	var subtitle := Label.new()
	subtitle.position = Vector2(26, 53)
	subtitle.text = "TRAINING GROUNDS"
	subtitle.add_theme_font_size_override("font_size", 13)
	ui_layer.add_child(subtitle)

	var coins := Label.new()
	coins.position = Vector2(1040, 22)
	coins.size = Vector2(210, 32)
	coins.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	coins.text = "COINS  %d" % economy.money
	coins.add_theme_font_size_override("font_size", 20)
	ui_layer.add_child(coins)

	map_panel = PanelContainer.new()
	map_panel.position = Vector2(250, 80)
	map_panel.size = Vector2(780, 560)
	map_panel.visible = false
	ui_layer.add_child(map_panel)
	_create_map_contents()

	equipment_panel = PanelContainer.new()
	equipment_panel.position = Vector2(30, 170)
	equipment_panel.size = Vector2(360, 390)
	equipment_panel.visible = false
	ui_layer.add_child(equipment_panel)

func _create_map_contents() -> void:
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 24)
	margin.add_theme_constant_override("margin_top", 20)
	margin.add_theme_constant_override("margin_right", 24)
	margin.add_theme_constant_override("margin_bottom", 20)
	map_panel.add_child(margin)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)
	margin.add_child(box)
	var title := Label.new()
	title.text = "KINGDOM MAP"
	title.add_theme_font_size_override("font_size", 28)
	box.add_child(title)
	var info := Label.new()
	info.text = "Travel to any discovered location. The archery range is reached directly from your grounds."
	info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(info)

	var locations := [
		["GREENFIELD", "Local tournament town"],
		["BLACKWOOD", "Forest settlement"],
		["EASTMERE", "Market town"],
		["KING'S CITY", "Royal capital"],
		["COASTAL PORT", "Harbour and trade"]
	]
	for location in locations:
		var button := Button.new()
		button.custom_minimum_size = Vector2(0, 54)
		button.text = "%s   •   %s" % [location[0], location[1]]
		button.pressed.connect(_travel_to.bind(location[0]))
		box.add_child(button)

	var close := Button.new()
	close.text = "CLOSE MAP"
	close.custom_minimum_size = Vector2(0, 44)
	close.pressed.connect(_close_all_panels)
	box.add_child(close)

func _refresh_equipment_panel() -> void:
	for child in equipment_panel.get_children():
		child.queue_free()
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 16)
	equipment_panel.add_child(margin)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	margin.add_child(box)
	var title := Label.new()
	title.text = "EQUIPMENT TENT"
	title.add_theme_font_size_override("font_size", 22)
	box.add_child(title)
	var stats_label := Label.new()
	stats_label.text = "STRENGTH %d    ACCURACY %d\nCOINS %d" % [stats.strength_level, stats.accuracy_level, economy.money]
	box.add_child(stats_label)
	for bow: BowData in bow_inventory.get_all_bows():
		var button := Button.new()
		var owned: bool = bow_inventory.is_owned(bow.id)
		if bow.id == bow_inventory.equipped_bow_id:
			button.text = "%s  [EQUIPPED]" % bow.display_name
			button.disabled = true
		elif owned:
			button.text = "%s  [EQUIP]" % bow.display_name
			button.pressed.connect(_equip_bow.bind(bow.id))
		else:
			button.text = "%s  $%d  STR %d" % [bow.display_name, bow.price, bow.required_strength]
			button.disabled = economy.money < bow.price or stats.strength_level < bow.required_strength
			button.pressed.connect(_buy_bow.bind(bow.id))
		box.add_child(button)
	var note := Label.new()
	note.text = "Character customization will expand this tent later."
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(note)
	var close := Button.new()
	close.text = "CLOSE"
	close.pressed.connect(_close_all_panels)
	box.add_child(close)

func _equip_bow(bow_id: String) -> void:
	if bow_inventory.equip(bow_id, stats.strength_level):
		_show_status("EQUIPPED %s" % bow_inventory.get_bow(bow_id).display_name)
		_refresh_equipment_panel()

func _buy_bow(bow_id: String) -> void:
	var bow: BowData = bow_inventory.get_bow(bow_id)
	if bow == null or not bow_inventory.can_purchase(bow_id, economy.money, stats.strength_level):
		return
	if not economy.spend_money(bow.price):
		return
	if bow_inventory.unlock(bow_id) and bow_inventory.equip(bow_id, stats.strength_level):
		_show_status("PURCHASED %s" % bow.display_name)
		_refresh_equipment_panel()

func _travel_to(destination: String) -> void:
	TravelState.destination = destination
	get_tree().change_scene_to_file("res://scenes/travel_location.tscn")

func _draw() -> void:
	var ground_y := 1584.0
	draw_rect(Rect2(-1400, ground_y, 5000, 500), Color("273125"))
	draw_line(Vector2(-1400, ground_y), Vector2(3600, ground_y), Color("66705a"), 6.0)
	_draw_city_backdrop()
	_draw_landmark(Vector2(TENT_X, ground_y), "TENT", Color("8c6848"))
	_draw_landmark(Vector2(MAP_X, ground_y), "MAP TABLE", Color("735238"))
	_draw_landmark(Vector2(FLETCHER_X, ground_y), "FLETCHER", Color("5d4b3c"))
	_draw_landmark(Vector2(RANGE_X, ground_y), "ARCHERY RANGE", Color("4e6347"))
	draw_line(Vector2(TENT_X + 180, ground_y + 20), Vector2(RANGE_X - 160, ground_y + 20), Color("8c7757"), 24.0)
	draw_line(Vector2(TENT_X + 180, ground_y + 20), Vector2(RANGE_X - 160, ground_y + 20), Color("b09a72"), 4.0)

func _draw_city_backdrop() -> void:
	var font := ThemeDB.fallback_font
	for i in range(14):
		var x := -1300.0 + float(i) * 360.0
		var h := 180.0 + float((i * 47) % 130)
		draw_rect(Rect2(x, 1584.0 - h - 210.0, 240.0, h), Color("303943"))
		if i % 3 == 0:
			draw_colored_polygon(PackedVector2Array([Vector2(x - 20, 1584.0 - h - 210.0), Vector2(x + 120, 1584.0 - h - 300.0), Vector2(x + 260, 1584.0 - h - 210.0)]), Color("3b4650"))
		draw_string(font, Vector2(x + 65, 1584.0 - 245.0), "CITY", HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color("56616b"))

func _draw_landmark(base: Vector2, label: String, body_color: Color) -> void:
	var w := 300.0
	var h := 230.0
	if label == "TENT":
		draw_colored_polygon(PackedVector2Array([base + Vector2(-150, 0), base + Vector2(0, -240), base + Vector2(150, 0)]), body_color)
		draw_line(base + Vector2(-150, 0), base + Vector2(0, -240), Color("c0a078"), 8.0)
		draw_line(base + Vector2(0, -240), base + Vector2(150, 0), Color("c0a078"), 8.0)
	else:
		draw_rect(Rect2(base + Vector2(-w / 2, -h), Vector2(w, h)), body_color)
		draw_rect(Rect2(base + Vector2(-w / 2 + 20, -h + 20), Vector2(w - 40, 50)), Color("30291f"))
		if label == "MAP TABLE":
			draw_rect(Rect2(base + Vector2(-115, -195), Vector2(230, 105)), Color("a78a5c"))
			draw_circle(base + Vector2(0, -142), 12, Color("d7a449"))
		elif label == "FLETCHER":
			for i in range(4):
				draw_line(base + Vector2(-95 + i * 55, -115), base + Vector2(-95 + i * 55, -15), Color("bda987"), 8.0)
		elif label == "ARCHERY RANGE":
			for i in range(3):
				var x := -85.0 + i * 85.0
				draw_circle(base + Vector2(x, -115), 38, Color("ded1ad"), false, 8.0)
				draw_circle(base + Vector2(x, -115), 13, Color("b35d43"), false, 6.0)
	var font := ThemeDB.fallback_font
	var width := font.get_string_size(label, HORIZONTAL_ALIGNMENT_LEFT, -1, 30).x
	draw_string(font, base + Vector2(-width / 2, 45), label, HORIZONTAL_ALIGNMENT_LEFT, -1, 30, Color("e8dfcc"))
