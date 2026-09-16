extends Node2D

const VIEW_SIZE := Vector2(1280.0, 720.0)

func _ready() -> void:
	queue_redraw()

func _draw() -> void:
	var size := get_viewport_rect().size
	var scale_factor := min(size.x / VIEW_SIZE.x, size.y / VIEW_SIZE.y)
	var offset := (size - VIEW_SIZE * scale_factor) * 0.5

	draw_rect(Rect2(Vector2.ZERO, size), Color("11161b"))

	_draw_range(offset, scale_factor)
	_draw_archer(offset + Vector2(190.0, 500.0) * scale_factor, scale_factor)
	_draw_bow(offset + Vector2(245.0, 435.0) * scale_factor, scale_factor)
	_draw_target(offset + Vector2(965.0, 360.0) * scale_factor, scale_factor)
	_draw_title(offset, scale_factor)

func _draw_range(offset: Vector2, scale_factor: float) -> void:
	var origin := offset
	var ground_y := 570.0 * scale_factor + offset.y
	var right := offset.x + VIEW_SIZE.x * scale_factor

	draw_rect(Rect2(origin, Vector2(VIEW_SIZE.x * scale_factor, 570.0 * scale_factor)), Color("1b2428"))
	draw_rect(Rect2(Vector2(offset.x, ground_y), Vector2(VIEW_SIZE.x * scale_factor, 150.0 * scale_factor)), Color("293126"))
	draw_line(Vector2(offset.x, ground_y), Vector2(right, ground_y), Color("4d5948"), 3.0 * scale_factor)

	for i in range(1, 8):
		var x := offset.x + float(i) * 160.0 * scale_factor
		draw_line(
			Vector2(x, ground_y),
			Vector2(x + 70.0 * scale_factor, ground_y - 55.0 * scale_factor),
			Color("34402f"),
			2.0 * scale_factor
		)

	# Target lane markers make the starting practice distance easy to read.
	var archer_x := offset.x + 245.0 * scale_factor
	var target_x := offset.x + 965.0 * scale_factor
	for marker_x in [archer_x, target_x]:
		draw_line(
			Vector2(marker_x, ground_y - 4.0 * scale_factor),
			Vector2(marker_x, ground_y + 8.0 * scale_factor),
			Color("68735d"),
			2.0 * scale_factor
		)

func _draw_archer(position: Vector2, scale_factor: float) -> void:
	var s := scale_factor
	# Simple silhouette placeholder. Art can replace this without changing gameplay layout.
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
	var s := scale_factor
	var top := position + Vector2(0, -65) * s
	var bottom := position + Vector2(0, 65) * s
	var grip := position
	var string_x := position.x + 32.0 * s

	draw_arc(grip, 65.0 * s, -PI * 0.5, PI * 0.5, 24, Color("8d603d"), 7.0 * s)
	draw_line(top, bottom, Color("d8d0bb"), 2.0 * s)
	draw_line(grip, Vector2(string_x, position.y), Color("d8d0bb"), 2.0 * s)

func _draw_target(center: Vector2, scale_factor: float) -> void:
	var s := scale_factor
	var radii := [92.0, 72.0, 52.0, 32.0, 14.0]
	var rings := [Color("ded6c4"), Color("8d4437"), Color("ded6c4"), Color("8d4437"), Color("d7a449")]

	for i in range(radii.size()):
		draw_circle(center, radii[i] * s, rings[i])

	draw_line(center + Vector2(-108, 0) * s, center + Vector2(108, 0) * s, Color("3b332d"), 2.0 * s)
	draw_line(center + Vector2(0, -108) * s, center + Vector2(0, 108) * s, Color("3b332d"), 2.0 * s)

	var stand_y := center.y + 92.0 * s
	draw_line(center + Vector2(-42, 88) * s, Vector2(center.x - 42.0 * s, stand_y + 118.0 * s), Color("654b34"), 10.0 * s)
	draw_line(center + Vector2(42, 88) * s, Vector2(center.x + 42.0 * s, stand_y + 118.0 * s), Color("654b34"), 10.0 * s)
	draw_line(Vector2(center.x - 65.0 * s, stand_y + 118.0 * s), Vector2(center.x + 65.0 * s, stand_y + 118.0 * s), Color("654b34"), 10.0 * s)

func _draw_title(offset: Vector2, scale_factor: float) -> void:
	var s := scale_factor
	draw_string(
		ThemeDB.fallback_font,
		offset + Vector2(46.0, 54.0) * s,
		"THE LAST ARCHER",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		30,
		Color("e8dfca")
	)

	draw_string(
		ThemeDB.fallback_font,
		offset + Vector2(48.0, 82.0) * s,
		"PRACTICE RANGE",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		16,
		Color("aeb6ad")
	)

	draw_string(
		ThemeDB.fallback_font,
		offset + Vector2(875.0, 640.0) * s,
		"Practice Target",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		18,
		Color("d8d0bb")
	)

	draw_string(
		ThemeDB.fallback_font,
		offset + Vector2(92.0, 655.0) * s,
		"ARCHER",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		16,
		Color("aeb6ad")
	)
