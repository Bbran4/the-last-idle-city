class_name Player
extends Node2D

const RECOVERY_RADIUS: float = 32.0
const RECOVERY_RING_WIDTH: float = 7.0
const RECOVERY_Y_OFFSET: float = -158.0
const RECOVERY_START_ANGLE: float = -PI / 2.0
const RECOVERY_BACKGROUND_COLOR := Color(0.12, 0.14, 0.17, 0.75)
const RECOVERY_PROGRESS_COLOR := Color("d7a449")

@onready var bow: Bow = $Bow

var recovery_progress: float = 0.0

func get_bow() -> Bow:
	return bow

func set_recovery_progress(progress: float) -> void:
	recovery_progress = clamp(progress, 0.0, 1.0)
	queue_redraw()

func _draw() -> void:
	if recovery_progress <= 0.0:
		return

	var center: Vector2 = Vector2(0.0, RECOVERY_Y_OFFSET)
	draw_arc(center, RECOVERY_RADIUS, 0.0, TAU, 32, RECOVERY_BACKGROUND_COLOR, RECOVERY_RING_WIDTH, true)
	var end_angle: float = RECOVERY_START_ANGLE + TAU * recovery_progress
	draw_arc(center, RECOVERY_RADIUS, RECOVERY_START_ANGLE, end_angle, 32, RECOVERY_PROGRESS_COLOR, RECOVERY_RING_WIDTH, true)
