class_name Player
extends Node2D

const RECOVERY_RADIUS: float = 32.0
const RECOVERY_RING_WIDTH: float = 7.0
const RECOVERY_Y_OFFSET: float = -158.0
const RECOVERY_START_ANGLE: float = -PI / 2.0
const RECOVERY_BACKGROUND_COLOR := Color(0.12, 0.14, 0.17, 0.75)
const RECOVERY_PROGRESS_COLOR := Color("d7a449")

const MOVE_SPEED: float = 520.0
const MIN_X: float = 80.0
const MAX_X: float = 3200.0
const GROUND_Y: float = 1656.0
const JUMP_SPEED: float = -760.0
const GRAVITY: float = 1800.0
const CROUCH_BODY_SCALE: float = 0.65
const MOVEMENT_WOBBLE_ANGLE: float = 0.045
const MOVEMENT_WOBBLE_SPEED: float = 10.0

@onready var bow: Bow = $Bow
@onready var body: Polygon2D = $Body
@onready var body_outline: Line2D = $BodyOutline

var recovery_progress: float = 0.0
var velocity: Vector2 = Vector2.ZERO
var movement_wobble: float = 0.0
var is_crouching: bool = false

func _physics_process(delta: float) -> void:
	var move_input: float = Input.get_axis("move_left", "move_right")
	velocity.x = move_input * MOVE_SPEED

	if Input.is_action_just_pressed("jump") and is_on_ground():
		velocity.y = JUMP_SPEED

	if not is_on_ground() or velocity.y < 0.0:
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0.0

	position.x = clamp(position.x + velocity.x * delta, MIN_X, MAX_X)
	position.y += velocity.y * delta
	if position.y >= GROUND_Y:
		position.y = GROUND_Y
		velocity.y = 0.0

	is_crouching = Input.is_action_pressed("crouch") and is_on_ground()
	var target_scale: float = CROUCH_BODY_SCALE if is_crouching else 1.0
	body.scale.y = move_toward(body.scale.y, target_scale, delta * 8.0)
	body_outline.scale.y = body.scale.y
	bow.position.y = lerp(-45.0, -20.0, 1.0 - body.scale.y)

	if abs(move_input) > 0.01 and is_on_ground():
		movement_wobble += delta * MOVEMENT_WOBBLE_SPEED
	else:
		movement_wobble = 0.0

	queue_redraw()

func is_on_ground() -> bool:
	return position.y >= GROUND_Y - 0.5

func is_airborne() -> bool:
	return not is_on_ground()

func is_crouched() -> bool:
	return is_crouching

func get_aim_wobble() -> float:
	if abs(velocity.x) <= 0.01 or not is_on_ground():
		return 0.0
	return sin(movement_wobble) * MOVEMENT_WOBBLE_ANGLE

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
