extends Node

var data: GameData


func _ready() -> void:
	data = GameData.new()


func reset_game() -> void:
	data = GameData.new()
