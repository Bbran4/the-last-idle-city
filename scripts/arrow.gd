class_name Arrow
extends Area2D

@export var damage: float = 10.0
@export var speed: float = 800.0
@export var arc_height_ratio: float = 0.18
@export var min_arc_height: float = 40.0
@export var max_arc_height: float = 260.0

var start_position: Vector2 = Vector2.ZERO
var target_position: Vector2 = Vector2.ZERO
var travel_time: float = 0.0
var elapsed_time: float = 0.0
var arc_height: float = 0.0

func setup(start_pos: Vector2, target_pos: Vector2, arrow_damage: float, arrow_speed: float) -> void:
	start_position = start_pos
	target_position = target_pos
	damage = arrow_damage
	speed = maxf(arrow_speed, 1.0)
	global_position = start_position

	var distance := start_position.distance_to(target_position)
	travel_time = distance / speed
	arc_height = clampf(distance * arc_height_ratio, min_arc_height, max_arc_height)
	elapsed_time = 0.0
	rotation = start_position.direction_to(target_position).angle()

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _physics_process(delta: float) -> void:
	if travel_time <= 0.0:
		queue_free()
		return

	elapsed_time += delta
	var t := clampf(elapsed_time / travel_time, 0.0, 1.0)

	var base_position := start_position.lerp(target_position, t)
	var arc_offset := -arc_height * sin(PI * t) # negative y = up on screen
	global_position = base_position + Vector2(0.0, arc_offset)

	var tangent := (target_position - start_position) + Vector2(0.0, -arc_height * PI * cos(PI * t))
	if tangent.length_squared() > 0.0001:
		rotation = tangent.angle()

	if t >= 1.0:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	var enemy := area.get_parent() as Enemy
	if enemy:
		enemy.take_damage(damage)
		queue_free()
