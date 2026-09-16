extends Node2D

const ARROW_SCENE: PackedScene = preload("res://scenes/arrow.tscn")
const VIEW_SIZE: Vector2 = Vector2(1280.0, 720.0)
const ARCHER_POSITION: Vector2 = Vector2(190.0, 500.0)
const BOW_POSITION: Vector2 = Vector2(245.0, 435.0)
const TARGET_POSITION: Vector2 = Vector2(965.0, 360.0)
const TARGET_RADIUS: float = 92.0
const MAX_DRAW_STRENGTH: float = 100.0
const DRAW_SPEED: float = 55.0
const MIN_LAUNCH_SPEED: float = 360.0
const MAX_LAUNCH_SPEED: float = 760.0
const IMPACT_FLASH_DURATION: float = 0.18

var draw_strength: float = 0.0
var is_drawing: bool = false
var active_arrow: Arrow = null
var impact_position: Vector2 = Vector2.ZERO
var impact_timer: float = 0.0

func _ready() -> void:
	queue_redraw()

func _process(delta: float) -> void:
	if is_drawing:
		draw_strength = min(draw_strength + DRAW_SPEED * delta, MAX_DRAW_STRENGTH)

	if impact_timer > 0.0:
		impact_timer = max(impact_timer - delta, 0.0)

	queue_redraw()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_R:
		_reset_arrows()
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and not is_drawing and active_arrow == null:
			is_drawing = true
			draw_strength = 0.0
			queue_redraw()
		elif not event.pressed and is_drawing:
			_release_arrow()

func _release_arrow() -> void:
	is_drawing = false
	if draw_strength <= 0.0:
		draw_strength = 0.0
		queue_redraw()
		return

	var strength_ratio: float = draw_strength / MAX_DRAW_STRENGTH
	var launch_speed: float = lerp(MIN_LAUNCH_SPEED, MAX_LAUNCH_SPEED, strength_ratio)
	var scale_factor: float = _get_scale_factor()
	var offset: Vector2 = _get_view_offset(scale_factor)
	var arrow: Arrow = ARROW_SCENE.instantiate() as Arrow
	arrow.position = offset + BOW_POSITION * scale_factor + Vector2(38.0, 0.0) * scale_factor
	arrow.scale = Vector2.ONE * scale_factor
	add_child(arrow)
	arrow.hit_target.connect(_on_arrow_hit)
	arrow.missed.connect(_on_arrow_missed)
	arrow.launch(
		Vector2(launch_speed, 0.0) * scale_factor,
		offset + TARGET_POSITION * scale_factor,
		TARGET_RADIUS * scale_factor
	)
	active_arrow = arrow
	draw_strength = 0.0
	queue_redraw()

func _on_arrow_hit(position: Vector2) -> void:
	if active_arrow == null:
		return

	active_arrow = null
	impact_position = position
	impact_timer = IMPACT_FLASH_DURATION
	queue_redraw()

func _on_arrow_missed() -> void:
	active_arrow = null
	queue_redraw()

func _reset_arrows() -> void:
	is_drawing = false
	draw_strength = 0.0
	active_arrow = null
	impact_timer = 0.0
	for child: Node in get_children():
		if child is Arrow:
			child.queue_free()
	queue_redraw()

func _get_scale_factor() -> float:
	var size: Vector2 = get_viewport_rect().size
	return min(size.x / VIEW_SIZE.x, size.y / VIEW_SIZE.y)

func _get_view_offset(scale_factor: float) -> Vector2:
	var size: Vector2 = get_viewport_rect().size
	return (size - VIEW_SIZE * scale_factor) * 0.5

func _draw() -> void:
	var size: Vector2 = get_viewport_rect().size
	var scale_factor: float = _get_scale_factor()
	var offset: Vector2 = _get_view_offset(scale_factor)

	draw_rect(Rect2(Vector2.ZERO, size), Color("11161b"))

	_draw_range(offset, scale_factor)
	_draw_archer(offset + ARCHER_POSITION * scale_factor, scale_factor)
	_draw_bow(offset + BOW_POSITION * scale_factor, scale_factor)
	_draw_target(offset + TARGET_POSITION * scale_factor, scale_factor)
	_draw_impact(offset, scale_factor)
	_draw_draw_strength(offset, scale_factor)
	_draw_title(offset, scale_factor)

func _draw_range(offset: Vector2, scale_factor: float) -> void:
	var origin: Vector2 = offset
	var ground_y: float = 570.0 * scale_factor + offset.y
	var right: float = offset.x + VIEW_SIZE.x * scale_factor

	draw_rect(Rect2(origin, Vector2(VIEW_SIZE.x * scale_factor, 570.0 * scale_factor)), Color("1b2428"))
	draw_rect(Rect2(Vector2(offset.x, ground_y), Vector2(VIEW_SIZE.x * scale_factor, 150.0 * scale_factor)), Color("293126"))
	draw_line(Vector2(offset.x, ground_y), Vector2(right, ground_y), Color("4d5948"), 3.0 * scale_factor)

	for i in range(1, 8):
		var x: float = offset.x + float(i) * 160.0 * scale_factor
		draw_line(Vector2(x, ground_y), Vector2(x + 70.0 * scale_factor, ground_y - 55.0 * scale_factor), Color("34402f"), 2.0 * scale_factor)

	var archer_x: float = offset.x + 245.0 * scale_factor
	var target_x: float = offset.x + 965.0 * scale_factor
	for marker_x: float in [archer_x, target_x]:
		draw_line(Vector2(marker_x, ground_y - 4.0 * scale_factor), Vector2(marker_x, ground_y + 8.0 * scale_factor), Color("68735d"), 2.0 * scale_factor)

func _draw_archer(position: Vector2, scale_factor: float) -> void:
	var s: float = scale_factor
	draw_circle(position + Vector2(0, -78) * s, 27.0 * s, Color("c7a875"))
	draw_colored_polygon(PackedVector2Array([
		position + Vector2(-32, -48) * s,
		position + Vector2(28, -48) * s,
		position + Vector2(40, 55) * s,
		position + Vector2(-40, 55) * s
	]), Color("405469"))
	draw_line(position + Vector2(-20, 0) * s, position + Vector2(-55, 62) * s, Color("26313a"), 12.0 * s)
	draw_line(position + Vector2(18, 0) * s, position + Vector2(45, 62) * s, Color("26313a"), 12.0 * s)
	draw_line(position + Vector2(24, -32) * s, position + Vector2(72, -8) * s, Color("c7a875"), 11.0 * s)

func _draw_bow(position: Vector2, scale_factor: float) -> void:
	var s: float = scale_factor
	var top: Vector2 = position + Vector2(0, -65) * s
	var bottom: Vector2 = position + Vector2(0, 65) * s
	var grip: Vector2 = position
	var string_x: float = position.x + 32.0 * s
	var pull_distance: float = 34.0 * s * (draw_strength / MAX_DRAW_STRENGTH)
	var string_anchor: Vector2 = Vector2(string_x - pull_distance, position.y)

	draw_arc(grip, 65.0 * s, -PI * 0.5, PI * 0.5, 24, Color("8d603d"), 7.0 * s)
	draw_line(top, bottom, Color("d8d0bb"), 2.0 * s)
	draw_line(top, string_anchor, Color("d8d0bb"), 2.0 * s)
	draw_line(string_anchor, bottom, Color("d8d0bb"), 2.0 * s)

	if is_drawing:
		draw_circle(string_anchor, 5.0 * s, Color("d7a449"))

func _draw_draw_strength(offset: Vector2, scale_factor: float) -> void:
	if not is_drawing:
		return

	var s: float = scale_factor
	var bar_position: Vector2 = offset + Vector2(420.0, 620.0) * s
	var bar_size: Vector2 = Vector2(440.0, 24.0) * s
	var fill_ratio: float = draw_strength / MAX_DRAW_STRENGTH

	draw_rect(Rect2(bar_position, bar_size), Color("20282c"), true)
	draw_rect(Rect2(bar_position, Vector2(bar_size.x * fill_ratio, bar_size.y)), Color("d7a449"), true)
	draw_rect(Rect2(bar_position, bar_size), Color("8f988f"), false, 2.0 * s)
	draw_string(ThemeDB.fallback_font, bar_position + Vector2(0.0, -10.0 * s), "DRAW STRENGTH  %d%%" % int(draw_strength), HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color("d8d0bb"))

func _draw_target(center: Vector2, scale_factor: float) -> void:
	var s: float = scale_factor
	var radii: Array[float] = [92.0, 72.0, 52.0, 32.0, 14.0]
	var rings: Array[Color] = [Color("ded6c4"), Color("8d4437"), Color("ded6c4"), Color("8d4437"), Color("d7a449")]

	for i in range(radii.size()):
		draw_circle(center, radii[i] * s, rings[i])

	draw_line(center + Vector2(-108, 0) * s, center + Vector2(108, 0) * s, Color("3b332d"), 2.0 * s)
	draw_line(center + Vector2(0, -108) * s, center + Vector2(0, 108) * s, Color("3b332d"), 2.0 * s)

	var stand_y: float = center.y + 92.0 * s
	draw_line(center + Vector2(-42, 88) * s, Vector2(center.x - 42.0 * s, stand_y + 118.0 * s), Color("654b34"), 10.0 * s)
	draw_line(center + Vector2(42, 88) * s, Vector2(center.x + 42.0 * s, stand_y + 118.0 * s), Color("654b34"), 10.0 * s)
	draw_line(Vector2(center.x - 65.0 * s, stand_y + 118.0 * s), Vector2(center.x + 65.0 * s, stand_y + 118.0 * s), Color("654b34"), 10.0 * s)

func _draw_impact(offset: Vector2, scale_factor: float) -> void:
	if impact_timer <= 0.0:
		return

	var progress: float = 1.0 - impact_timer / IMPACT_FLASH_DURATION
	var radius: float = lerp(10.0, 28.0, progress) * scale_factor
	draw_circle(impact_position, radius, Color(0.84, 0.66, 0.29, 0.35 * (1.0 - progress)), false, 4.0 * scale_factor)
	draw_circle(impact_position, 4.0 * scale_factor, Color("d7a449"))

func _draw_title(offset: Vector2, scale_factor: float) -> void:
	var s: float = scale_factor
	draw_string(ThemeDB.fallback_font, offset + Vector2(46.0, 54.0) * s, "THE LAST ARCHER", HORIZONTAL_ALIGNMENT_LEFT, -1, 30, Color("e8dfca"))
	draw_string(ThemeDB.fallback_font, offset + Vector2(48.0, 82.0) * s, "PRACTICE RANGE", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color("aeb6ad"))
	draw_string(ThemeDB.fallback_font, offset + Vector2(875.0, 640.0) * s, "Practice Target", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color("d8d0bb"))
	draw_string(ThemeDB.fallback_font, offset + Vector2(92.0, 655.0) * s, "ARCHER", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color("aeb6ad"))
	draw_string(ThemeDB.fallback_font, offset + Vector2(40.0, 690.0) * s, "R  RESET ARROWS", HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color("7f8982"))

	if not is_drawing and active_arrow == null:
		draw_string(ThemeDB.fallback_font, offset + Vector2(450.0, 680.0) * s, "HOLD LEFT MOUSE BUTTON TO DRAW", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color("aeb6ad"))
