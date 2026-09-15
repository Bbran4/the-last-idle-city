class_name Ally
extends Unit

@export var target: Node2D

func _process(_delta: float) -> void:
	# Ally targeting and combat are implemented after the core combat loop.
	if target == null or is_dead:
		return
