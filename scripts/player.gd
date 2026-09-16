class_name Player
extends Node2D

@onready var bow: Bow = $Bow

func get_bow() -> Bow:
	return bow
