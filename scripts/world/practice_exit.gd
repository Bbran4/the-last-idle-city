extends Node

const HUB_EXIT_X: float = -1250.0
const INTERACTION_RADIUS: float = 220.0
var player: Player
var returning: bool = false
var prompt_label: Label

func _ready() -> void:
	player = get_parent().get_node_or_null("WorldView/Player") as Player
	prompt_label = Label.new()
	prompt_label.position = Vector2(0, 650)
	prompt_label.size = Vector2(1280, 40)
	prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	prompt_label.add_theme_font_size_override("font_size", 18)
	prompt_label.visible = false
	var canvas := CanvasLayer.new()
	canvas.layer = 10
	add_child(canvas)
	canvas.add_child(prompt_label)

func _process(_delta: float) -> void:
	if returning or player == null:
		return
	var near_exit := player.position.x <= HUB_EXIT_X + INTERACTION_RADIUS
	prompt_label.text = "E  RETURN TO HUB" if near_exit else ""
	prompt_label.visible = near_exit

func _unhandled_input(event: InputEvent) -> void:
	if returning or player == null:
		return
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_E:
		if player.position.x <= HUB_EXIT_X + INTERACTION_RADIUS:
			returning = true
			prompt_label.visible = false
			TravelState.return_spawn = "ARCHERY_RANGE"
			TravelState.destination = "TRAINING GROUNDS"
			get_tree().change_scene_to_file("res://scenes/hub.tscn")
