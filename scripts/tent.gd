class_name CustomizationTent
extends Node2D

func _ready() -> void:
	queue_redraw()

func _draw() -> void:
	var ground_y: float = 0.0
	var left: float = -150.0
	var right: float = 150.0
	var peak: Vector2 = Vector2(0.0, -180.0)
	var base_left: Vector2 = Vector2(left, ground_y)
	var base_right: Vector2 = Vector2(right, ground_y)

	draw_colored_polygon(PackedVector2Array([base_left, peak, base_right]), Color("6b4a35"))
	draw_polyline(PackedVector2Array([base_left, peak, base_right]), Color("b68a5d"), 8.0, true)

	var entrance := PackedVector2Array([
		Vector2(-42.0, ground_y),
		Vector2(0.0, -105.0),
		Vector2(42.0, ground_y)
	])
	draw_colored_polygon(entrance, Color("302a25"))
	draw_polyline(PackedVector2Array([Vector2(-42.0, ground_y), Vector2(0.0, -105.0), Vector2(42.0, ground_y)]), Color("8e6b4d"), 5.0, true)

	draw_line(Vector2(-150.0, 0.0), Vector2(-150.0, -195.0), Color("4b3829"), 8.0)
	draw_line(Vector2(150.0, 0.0), Vector2(150.0, -195.0), Color("4b3829"), 8.0)
	draw_circle(Vector2(205.0, -8.0), 18.0, Color("d66b32"))
	draw_circle(Vector2(205.0, -8.0), 9.0, Color("f1c35b"))

	draw_rect(Rect2(-95.0, 28.0, 190.0, 48.0), Color("5b402d"))
	draw_rect(Rect2(-95.0, 28.0, 190.0, 48.0), Color("b68a5d"), false, 4.0)
	draw_string(ThemeDB.fallback_font, Vector2(-65.0, 60.0), "CUSTOMIZE", HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color("e5d5b8"))
