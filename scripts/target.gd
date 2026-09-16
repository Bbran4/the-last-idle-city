class_name Target
extends Area2D

## Each target controls its own difficulty and coin reward.
## Range expansion can place targets at different distances and scales.

@export var coin_reward: int = 1
@export var is_ring_target: bool = false

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func get_radius() -> float:
	var shape: Shape2D = collision_shape.shape
	if shape is CircleShape2D:
		return (shape as CircleShape2D).radius * abs(global_scale.x)
	return 100.0 * abs(global_scale.x)

func get_coin_reward() -> int:
	if is_ring_target:
		return 5
	return clamp(coin_reward, 1, 3)

func get_reward_label() -> String:
	if is_ring_target:
		return "RING TARGET  +5 COINS"
	return "+%d COINS" % get_coin_reward()
