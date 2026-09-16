class_name Arrow
extends Node2D

signal hit_target(position: Vector2)
signal missed

const GRAVITY: float = 180.0
const MAX_DISTANCE: float = 900.0

var velocity: Vector2 = Vector2.ZERO
var distance_traveled: float = 0.0
var target_position: Vector2 = Vector2.ZERO
var target_radius: float = 92.0
var is_embedded: bool = false

func launch(initial_velocity: Vector2, target: Vector2, radius: float) -> void:
	velocity = initial_velocity
	distance_traveled = 0.0
	target_position = target
	target_radius = radius
	is_embedded = false
	rotation = velocity.angle()
	queue_redraw()

func _process(delta: float) -> void:
	if is_embedded:
		return

	var previous_position: Vector2 = position
	var movement: Vector2 = velocity * delta
	position += movement
	distance_traveled += movement.length()
	velocity.y += GRAVITY * delta

	if velocity.length_squared() > 0.0:
		rotation = velocity.angle()

	var hit_position: Vector2 = _segment_circle_hit(previous_position, position, target_position, target_radius)
	if hit_position != Vector2.INF:
		position = hit_position
		embed()
		hit_target.emit(position)
		return

	if distance_traveled >= MAX_DISTANCE or position.y > 820.0:
		missed.emit()
		queue_free()
		return

	queue_redraw()

func embed() -> void:
	is_embedded = true
	velocity = Vector2.ZERO
	queue_redraw()

func _segment_circle_hit(start: Vector2, end: Vector2, center: Vector2, radius: float) -> Vector2:
	var segment: Vector2 = end - start
	var segment_length_squared: float = segment.length_squared()
	if segment_length_squared <= 0.0:
		if start.distance_to(center) <= radius:
			return start
		return Vector2.INF

	var projection: float = clamp((center - start).dot(segment) / segment_length_squared, 0.0, 1.0)
	var closest: Vector2 = start + segment * projection
	if closest.distance_to(center) <= radius:
		return closest

	return Vector2.INF

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
