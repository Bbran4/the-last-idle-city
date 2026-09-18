extends Node2D

@onready var title_label: Label = $UI/Panel/VBox/Title
@onready var description_label: Label = $UI/Panel/VBox/Description

func _ready() -> void:
	title_label.text = TravelState.destination
	description_label.text = "You have travelled here from the Training Grounds. This location is ready to become a full world activity later."
	queue_redraw()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
		_return_home()

func _return_home() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_return_pressed() -> void:
	_return_home()

func _draw() -> void:
	draw_rect(Rect2(-1000, 0, 3000, 1600), Color("252a2c"))
	draw_rect(Rect2(-1000, 980, 3000, 620), Color("30382f"))
	draw_line(Vector2(-1000, 980), Vector2(2000, 980), Color("68705e"), 6.0)
	for i in range(8):
		var x := -800.0 + float(i) * 420.0
		draw_circle(Vector2(x, 900), 150.0, Color("35443a"))
