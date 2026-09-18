extends Node

const HUB_EXIT_X: float = -1250.0
var player: Player
var returning: bool = false

func _ready() -> void:
	player = get_parent().get_node_or_null("WorldView/Player") as Player

func _process(_delta: float) -> void:
	if returning or player == null:
		return
	if player.position.x <= HUB_EXIT_X:
		returning = true
		TravelState.destination = "TRAINING GROUNDS"
		get_tree().change_scene_to_file("res://scenes/hub.tscn")
