class_name Arrow
extends Area2D

@export var damage: float = 10.0
@export var speed: float = 800.0
@export var max_distance: float = 2000.0

var direction: Vector2 = Vector2.RIGHT
var distance_travelled: float = 0.0

func setup(start_position: Vector2, target_position: Vector2, arrow_damage: float, arrow_speed: float) -> void:
	global_position = start_position
	damage = arrow_damage
	speed = arrow_speed
	direction = start_position.direction_to(target_position)
	rotation = direction.angle()

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _physics_process(delta: float) -> void:
	var movement := direction * speed * delta
	global_position += movement
	distance_travelled += movement.length()
	if distance_travelled >= max_distance:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	var enemy := area.get_parent() as Enemy
	if enemy:
		enemy.take_damage(damage)
		queue_free()
