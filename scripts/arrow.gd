class_name Arrow
extends Node2D

const GRAVITY: float = 420.0
const MAX_DISTANCE: float = 900.0

var velocity: Vector2 = Vector2.ZERO
var distance_traveled: float = 0.0
var is_embedded: bool = false

func launch(initial_velocity: Vector2) -> void:
	velocity = initial_velocity
	distance_traveled = 0.0
	is_embedded = false
	rotation = velocity.angle()
	queue_redraw()

func _process(delta: float) -> void:
	if is_embedded:
		return

	var movement: Vector2 = velocity * delta
	position += movement
	distance_traveled += movement.length()
	velocity.y += GRAVITY * delta

	if velocity.length_squared() > 0.0:
		rotation = velocity.angle()

	if distance_traveled >= MAX_DISTANCE or position.y > 820.0:
		queue_free()
		return

	queue_redraw()

func embed() -> void:
	is_embedded = true
	velocity = Vector2.ZERO
	queue_redraw()

func _draw() -> void:
	var arrow_length: float = 48.0
	var arrow_head: float = 10.0
	var head: Vector2 = Vector2(arrow_head, 0.0)
	var tail: Vector2 = Vector2(-arrow_length, 0.0)

	draw_line(tail, head, Color("d8d0bb"), 3.0)
	draw_colored_polygon(PackedVector2Array([
		head,
		head - Vector2(1.0, 0.0).rotated(0.55) * 14.0,
		head - Vector2(1.0, 0.0).rotated(-0.55) * 14.0
	]), Color("c7a875"))
