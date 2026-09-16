extends Node2D

const ARROW_SCENE: PackedScene = preload("res://scenes/arrow.tscn")
const WORLD_SCALE: float = 0.40
const PLAYER_POSITION: Vector2 = Vector2(350.0, 500.0)
const BOW_POSITION: Vector2 = Vector2(405.0, 455.0)
const TARGET_POSITION: Vector2 = Vector2(2200.0, 400.0)
const TARGET_RADIUS: float = 100.0
const GROUND_Y: float = 1250.0
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
	var mouse_position: Vector2 = _get_world_mouse_position()
	var aim_vector: Vector2 = mouse_position - BOW_POSITION
	if aim_vector.length_squared() > 0.001:
		aim_angle = aim_vector.angle()

func _get_world_mouse_position() -> Vector2:
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
	arrow.position = BOW_POSITION + direction * 28.0
	arrow.scale = Vector2.ONE * WORLD_SCALE
	add_child(arrow)
	arrow.hit_target.connect(_on_arrow_hit)
	arrow.missed.connect(_on_arrow_missed)
	arrow.launch(
		direction * launch_speed,
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

	if distance <= 16.0:
		return {"score": 10, "label": "BULLSEYE  +10", "is_bullseye": true}
	if distance <= 36.0:
		return {"score": 9, "label": "9 RING  +9", "is_bullseye": false}
	if distance <= 56.0:
		return {"score": 8, "label": "8 RING  +8", "is_bullseye": false}
	if distance <= 78.0:
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
	var ground_screen_y: float = GROUND_Y * WORLD_SCALE

	draw_rect(Rect2(Vector2.ZERO, size), Color("15191d"))
	draw_rect(Rect2(0.0, ground_screen_y, size.x, size.y - ground_screen_y), Color("293126"))
	draw_line(Vector2(0.0, ground_screen_y), Vector2(size.x, ground_screen_y), Color("4d5948"), 2.0)

	_draw_player(PLAYER_POSITION * WORLD_SCALE)
	_draw_bow(BOW_POSITION * WORLD_SCALE)
	_draw_target(TARGET_POSITION * WORLD_SCALE)
	_draw_impact()
	_draw_draw_strength(size)
	_draw_hud()
	_draw_title()

func _draw_player(screen_position: Vector2) -> void:
	var size: Vector2 = Vector2(100.0, 120.0) * WORLD_SCALE
	var rect: Rect2 = Rect2(screen_position - Vector2(size.x * 0.5, size.y), size)
	draw_rect(rect, Color("6d7f91"), true)
	draw_rect(rect, Color("aeb8c0"), false, 2.0)

func _draw_bow(screen_position: Vector2) -> void:
	var direction: Vector2 = Vector2.RIGHT.rotated(aim_angle)
	var perpendicular: Vector2 = direction.rotated(PI * 0.5)
	var bow_length: float = 70.0 * WORLD_SCALE
	var top: Vector2 = screen_position + perpendicular * bow_length
	var bottom: Vector2 = screen_position - perpendicular * bow_length
	var string_rest: Vector2 = screen_position + direction * 18.0 * WORLD_SCALE
	var pull_distance: float = 24.0 * WORLD_SCALE * (draw_strength / MAX_DRAW_STRENGTH)
	var string_anchor: Vector2 = string_rest - direction * pull_distance

	draw_line(top, bottom, Color("8d603d"), 4.0)
	draw_line(top, string_anchor, Color("d8d0bb"), 1.5)
	draw_line(string_anchor, bottom, Color("d8d0bb"), 1.5)

	if is_drawing:
		draw_circle(string_anchor, 3.0, Color("d7a449"))

func _draw_target(screen_position: Vector2) -> void:
	var radius: float = TARGET_RADIUS * WORLD_SCALE
	draw_circle(screen_position, radius, Color("ded6c4"))
	draw_circle(screen_position, radius * 0.72, Color("8d4437"))
	draw_circle(screen_position, radius * 0.52, Color("ded6c4"))
	draw_circle(screen_position, radius * 0.32, Color("8d4437"))
	draw_circle(screen_position, radius * 0.16, Color("d7a449"))

func _draw_impact() -> void:
	if impact_timer <= 0.0:
		return

	var progress: float = 1.0 - impact_timer / IMPACT_FLASH_DURATION
	var radius: float = lerp(5.0, 14.0, progress)
	draw_circle(impact_position * WORLD_SCALE, radius, Color("d7a449"), false, 2.0)
	draw_circle(impact_position * WORLD_SCALE, 2.0, Color("d7a449"))

func _draw_draw_strength(size: Vector2) -> void:
	if not is_drawing:
		return

	var bar_size: Vector2 = Vector2(360.0, 18.0)
	var bar_position: Vector2 = Vector2((size.x - bar_size.x) * 0.5, size.y - 50.0)
	var fill_ratio: float = draw_strength / MAX_DRAW_STRENGTH

	draw_rect(Rect2(bar_position, bar_size), Color("20282c"), true)
	draw_rect(Rect2(bar_position, Vector2(bar_size.x * fill_ratio, bar_size.y)), Color("d7a449"), true)
	draw_rect(Rect2(bar_position, bar_size), Color("8f988f"), false, 2.0)
	draw_string(ThemeDB.fallback_font, bar_position + Vector2(0.0, -8.0), "DRAW  %d%%" % int(draw_strength), HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color("d8d0bb"))

func _draw_hud() -> void:
	var hud_position: Vector2 = Vector2(24.0, 70.0)
	draw_string(ThemeDB.fallback_font, hud_position, "SCORE  %d" % total_score, HORIZONTAL_ALIGNMENT_LEFT, -1, 24, Color("e8dfca"))
	draw_string(ThemeDB.fallback_font, hud_position + Vector2(0.0, 22.0), "SHOTS  %d    HITS  %d    BULLSEYES  %d" % [shots_fired, successful_hits, bullseyes], HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color("aeb6ad"))

	if shot_result_timer > 0.0:
		var result_position: Vector2 = Vector2(get_viewport_rect().size.x * 0.5 - 120.0, 70.0)
		draw_string(ThemeDB.fallback_font, result_position, last_shot_label, HORIZONTAL_ALIGNMENT_CENTER, 240.0, 20, Color("d7a449"))

func _draw_title() -> void:
	draw_string(ThemeDB.fallback_font, Vector2(24.0, 34.0), "THE LAST ARCHER", HORIZONTAL_ALIGNMENT_LEFT, -1, 28, Color("e8dfca"))
	draw_string(ThemeDB.fallback_font, Vector2(26.0, 52.0), "PRACTICE RANGE", HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color("8f988f"))
