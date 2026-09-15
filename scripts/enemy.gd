class_name Enemy
extends Unit

@export var coin_reward: int = 1
@export var movement_speed: float = 80.0
@export var castle_damage: float = 10.0

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	# Movement and castle interaction are implemented in Milestone 1.
	position.x -= movement_speed * delta
