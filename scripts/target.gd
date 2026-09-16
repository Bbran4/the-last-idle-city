class_name Target
extends Area2D

## The target defines its own hit radius via its CollisionShape2D, so moving
## or resizing it in the editor is all that's needed -- nothing elsewhere
## needs to know its position or size as a hardcoded number.

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func get_radius() -> float:
	var shape: Shape2D = collision_shape.shape
	if shape is CircleShape2D:
		return (shape as CircleShape2D).radius
	return 100.0

## `local_hit_position` must be in the same coordinate space as this node's
## own `position` (i.e. the local space of its parent, WorldView) -- which
## is exactly the space Arrow reports hits in.
func calculate_score(local_hit_position: Vector2) -> Dictionary:
	var radius: float = get_radius()
	var distance: float = local_hit_position.distance_to(position)
	var ratio: float = distance / radius if radius > 0.0 else 1.0

	if ratio <= 0.16:
		return {"score": 10, "label": "BULLSEYE  +10", "is_bullseye": true}
	if ratio <= 0.36:
		return {"score": 9, "label": "9 RING  +9", "is_bullseye": false}
	if ratio <= 0.56:
		return {"score": 8, "label": "8 RING  +8", "is_bullseye": false}
	if ratio <= 0.78:
		return {"score": 7, "label": "7 RING  +7", "is_bullseye": false}
	return {"score": 6, "label": "6 RING  +6", "is_bullseye": false}
