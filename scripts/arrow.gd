class_name Arrow
extends Area2D

@export var damage: float = 10.0
@export var speed: float = 800.0
@export var _gravity: float = 1400.0
@export var max_flight_time: float = 5.0

var velocity: Vector2 = Vector2.ZERO
var ground_y: float = 0.0
var elapsed_time: float = 0.0

func setup(start_position: Vector2, target_position: Vector2, arrow_damage: float, arrow_speed: float, ground_level_y: float = 0.0) -> void:
	global_position = start_position
	damage = arrow_damage
	speed = maxf(arrow_speed, 1.0)
	elapsed_time = 0.0

	# Mouse position is only used here, to pick an initial velocity. Nothing
	# after this point looks at target_position again.
	var to_target := target_position - start_position
	var distance := to_target.length()
	var flight_time := maxf(distance / speed, 0.05)

	velocity = Vector2(
		to_target.x / flight_time,
		(to_target.y - 0.5 * _gravity * flight_time * flight_time) / flight_time
	)

	# Fall back to a sensible ground level if none was supplied, so the arrow
	# always has somewhere to land.
	ground_y = maxf(ground_level_y, maxf(start_position.y, target_position.y) + 40.0)

	rotation = velocity.angle()

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _physics_process(delta: float) -> void:
	elapsed_time += delta
	velocity.y += _gravity * delta
	global_position += velocity * delta
	rotation = velocity.angle()

	if global_position.y >= ground_y or elapsed_time >= max_flight_time:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	var enemy := area.get_parent() as Enemy
	if enemy:
		enemy.take_damage(damage)
		queue_free()
