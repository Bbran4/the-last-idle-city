extends Node2D

const ARROW_SCENE: PackedScene = preload("res://scenes/arrow.tscn")
const WORLD_SCALE: float = 0.70
const ARCHER_POSITION: Vector2 = Vector2(190.0, 500.0)
const BOW_POSITION: Vector2 = Vector2(245.0, 435.0)
const TARGET_POSITION: Vector2 = Vector2(965.0, 360.0)
const TARGET_RADIUS: float = 92.0
const GROUND_Y: float = 570.0
const MAX_DRAW_STRENGTH: float = 100.0
const DRAW_SPEED: float = 55.0
const MIN_LAUNCH_SPEED: float = 360.0
const MAX_LAUNCH_SPEED: float = 760.0
const IMPACT_FLASH_DURATION: float = 0.18
const SHOT_RESULT_DURATION: float = 1.5

var draw_strength: float = 0.0
var is_drawing: bool = false
var active_arrow: Arrow = null
var impact_position: Vector2 = Vector2.ZERO
var impact_timer: float = 0.0
var aim_angle: float = 0.0
var shot_result_timer: float = 0.0

var total_score: int = 0
var shots_fired: int = 0
var successful_hits: int = 0
var bullseyes: int = 0
var last_shot_score: int = 0
var last_shot_label: String = ""

func _ready() -> void:
	queue_redraw()

func _process(delta: float) -> void:
	_update_aim()

	if is_drawing:
		draw_strength = min(draw_strength + DRAW_SPEED * delta, MAX_DRAW_STRENGTH)

	if impact_timer > 0.0:
		impact_timer = max(impact_timer - delta, 0.0)

	if shot_result_timer > 0.0:
		shot_result_timer = max(shot_result_timer - delta, 0.0)

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

func _update_aim() -> void:
	var mouse_position: Vector2 = _get_design_mouse_position()
	var aim_vector: Vector2 = mouse_position - BOW_POSITION
	if aim_vector.length_squared() > 0.001:
		aim_angle = aim_vector.angle()

func _get_design_mouse_position() -> Vector2:
	return get_viewport().get_mouse_position() / WORLD_SCALE

func _release_arrow() -> void:
	is_drawing = false
	if draw_strength <= 0.0:
		draw_strength = 0.0
		queue_redraw()
		return

	var strength_ratio: float = draw_strength / MAX_DRAW_STRENGTH
	var launch_speed: float = lerp(MIN_LAUNCH_SPEED, MAX_LAUNCH_SPEED, strength_ratio)
	var direction: Vector2 = Vector2.RIGHT.rotated(aim_angle)
	var arrow: Arrow = ARROW_SCENE.instantiate() as Arrow
	arrow.position = BOW_POSITION + direction * 38.0
	arrow.scale = Vector2.ONE * WORLD_SCALE
	add_child(arrow)
	arrow.hit_target.connect(_on_arrow_hit)
	arrow.missed.connect(_on_arrow_missed)
	arrow.launch(
		direction * launch_speed * WORLD_SCALE,
		TARGET_POSITION,
		TARGET_RADIUS,
		GROUND_Y,
		0.0,
		get_viewport_rect().size.x / WORLD_SCALE
	)

	active_arrow = arrow
	shots_fired += 1
	last_shot_label = "SHOT FIRED"
	shot_result_timer = SHOT_RESULT_DURATION
	draw_strength = 0.0
	queue_redraw()

func _on_arrow_hit(position: Vector2) -> void:
	if active_arrow == null:
		return

	var score_result: Dictionary = _calculate_score(position)
	last_shot_score = score_result.score
	last_shot_label = score_result.label
	total_score += last_shot_score
	successful_hits += 1
	if score_result.is_bullseye:
		bullseyes += 1

	active_arrow = null
	impact_position = position
	impact_timer = IMPACT_FLASH_DURATION
	shot_result_timer = SHOT_RESULT_DURATION
	queue_redraw()

func _on_arrow_missed() -> void:
	active_arrow = null
	last_shot_score = 0
	last_shot_label = "MISS"
	shot_result_timer = SHOT_RESULT_DURATION
	queue_redraw()

func _calculate_score(position: Vector2) -> Dictionary:
	var distance: float = position.distance_to(TARGET_POSITION)

	if distance <= 14.0:
		return {"score": 10, "label": "BULLSEYE  +10", "is_bullseye": true}
	if distance <= 32.0:
		return {"score": 9, "label": "9 RING  +9", "is_bullseye": false}
	if distance <= 52.0:
		return {"score": 8, "label": "8 RING  +8", "is_bullseye": false}
	if distance <= 72.0:
		return {"score": 7, "label": "7 RING  +7", "is_bullseye": false}
	return {"score": 6, "label": "6 RING  +6", "is_bullseye": false}

func _reset_arrows() -> void:
	is_drawing = false
	draw_strength = 0.0
	active_arrow = null
	impact_timer = 0.0
	shot_result_timer = 0.0
	for child: Node in get_children():
		if child is Arrow:
			child.queue_free()
	queue_redraw()

func _draw() -> void:
	var size: Vector2 = get_viewport_rect().size
	var scale_factor: float = WORLD_SCALE

	draw_rect(Rect2(Vector2.ZERO, size), Color("11161b"))
	_draw_range(scale_factor, size)
	_draw_archer(ARCHER_POSITION * scale_factor, scale_factor)
	_draw_bow(BOW_POSITION * scale_factor, scale_factor)
	_draw_target(TARGET_POSITION * scale_factor, scale_factor)
	_draw_impact(scale_factor)
	_draw_draw_strength(scale_factor, size)
	_draw_hud(scale_factor)
	_draw_title()

func _draw_range(scale_factor: float, size: Vector2) -> void:
	var ground_y: float = GROUND_Y * scale_factor

	draw_rect(Rect2(Vector2.ZERO, Vector2(size.x, ground_y)), Color("1b2428"))
	draw_rect(Rect2(Vector2(0.0, ground_y), Vector2(size.x, size.y - ground_y)), Color("293126"))
	draw_line(Vector2(0.0, ground_y), Vector2(size.x, ground_y), Color("4d5948"), 3.0 * scale_factor)

	var world_right: float = size.x / scale_factor
	for i in range(1, int(world_right / 160.0) + 1):
		var x: float = float(i) * 160.0 * scale_factor
		draw_line(Vector2(x, ground_y), Vector2(x + 70.0 * scale_factor, ground_y - 55.0 * scale_factor), Color("34402f"), 2.0 * scale_factor)

	for marker_x: float in [ARCHER_POSITION.x, TARGET_POSITION.x]:
		var screen_x: float = marker_x * scale_factor
		draw_line(Vector2(screen_x, ground_y - 4.0 * scale_factor), Vector2(screen_x, ground_y + 8.0 * scale_factor), Color("68735d"), 2.0 * scale_factor)

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
	var direction: Vector2 = Vector2.RIGHT.rotated(aim_angle)
	var perpendicular: Vector2 = direction.rotated(PI * 0.5)
	var grip: Vector2 = position
	var top: Vector2 = grip + perpendicular * 65.0 * s
	var bottom: Vector2 = grip - perpendicular * 65.0 * s
	var string_rest: Vector2 = grip + direction * 32.0 * s
	var pull_distance: float = 34.0 * s * (draw_strength / MAX_DRAW_STRENGTH)
	var string_anchor: Vector2 = string_rest - direction * pull_distance

	draw_arc(grip, 65.0 * s, aim_angle - PI * 0.5, aim_angle + PI * 0.5, 24, Color("8d603d"), 7.0 * s)
	draw_line(top, bottom, Color("d8d0bb"), 2.0 * s)
	draw_line(top, string_anchor, Color("d8d0bb"), 2.0 * s)
	draw_line(string_anchor, bottom, Color("d8d0bb"), 2.0 * s)

	if is_drawing:
		draw_circle(string_anchor, 5.0 * s, Color("d7a449"))

func _draw_draw_strength(scale_factor: float, size: Vector2) -> void:
	if not is_drawing:
		return

	var s: float = scale_factor
	var bar_size: Vector2 = Vector2(440.0, 24.0) * s
	var bar_position: Vector2 = Vector2((size.x - bar_size.x) * 0.5, size.y - 70.0)
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

func _draw_impact(scale_factor: float) -> void:
	if impact_timer <= 0.0:
		return

	var progress: float = 1.0 - impact_timer / IMPACT_FLASH_DURATION
	var radius: float = lerp(10.0, 28.0, progress) * scale_factor
	draw_circle(impact_position * scale_factor, radius, Color(0.84, 0.66, 0.29, 0.35 * (1.0 - progress)), false, 4.0 * scale_factor)
	draw_circle(impact_position * scale_factor, 4.0 * scale_factor, Color("d7a449"))

func _draw_hud(scale_factor: float) -> void:
	var hud_position: Vector2 = Vector2(32.0, 72.0)
	draw_string(ThemeDB.fallback_font, hud_position, "SCORE  %d" % total_score, HORIZONTAL_ALIGNMENT_LEFT, -1, 24, Color("e8dfca"))
	draw_string(ThemeDB.fallback_font, hud_position + Vector2(0.0, 24.0), "SHOTS  %d    HITS  %d    BULLSEYES  %d" % [shots_fired, successful_hits, bullseyes], HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color("aeb6ad"))

	if shot_result_timer > 0.0:
		var result_position: Vector2 = Vector2(get_viewport_rect().size.x * 0.5 - 120.0, 72.0)
		draw_string(ThemeDB.fallback_font, result_position, last_shot_label, HORIZONTAL_ALIGNMENT_CENTER, 240.0, 22, Color("d7a449"))

func _draw_title() -> void:
	draw_string(ThemeDB.fallback_font, Vector2(32.0, 34.0), "THE LAST ARCHER", HORIZONTAL_ALIGNMENT_LEFT, -1, 30, Color("e8dfca"))
	draw_string(ThemeDB.fallback_font, Vector2(34.0, 55.0), "PRACTICE RANGE", HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color("8f988f"))
