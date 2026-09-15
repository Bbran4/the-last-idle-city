class_name Projectile
extends Area2D

@export var damage: float = 10.0
@export var speed: float = 800.0

var direction: Vector2 = Vector2.RIGHT
var distance_travelled: float = 0.0
@export var max_distance: float = 2000.0

func setup(start_position: Vector2, target_position: Vector2, projectile_damage: float, projectile_speed: float) -> void:
	global_position = start_position
	damage = projectile_damage
	speed = projectile_speed
	direction = start_position.direction_to(target_position)
	rotation = direction.angle()

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
