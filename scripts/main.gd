extends Node2D

func _ready() -> void:
	queue_redraw()

func _draw() -> void:
	var size := get_viewport_rect().size
	var center := size * 0.5

	draw_string(
		ThemeDB.fallback_font,
		center + Vector2(-145.0, -20.0),
		"THE LAST ARCHER",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		36,
		Color(0.92, 0.88, 0.76, 1.0)
	)

	draw_string(
		ThemeDB.fallback_font,
		center + Vector2(-116.0, 22.0),
		"Milestone 0 - Foundation",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		20,
		Color(0.65, 0.68, 0.74, 1.0)
	)

	draw_string(
		ThemeDB.fallback_font,
		center + Vector2(-94.0, 68.0),
		"Hold. Aim. Release.",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		18,
		Color(0.76, 0.78, 0.82, 1.0)
	)
