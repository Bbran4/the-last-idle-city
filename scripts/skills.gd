class_name Skills
extends Resource

@export var power_shot_unlocked: bool = false
@export var multi_shot_unlocked: bool = false
@export var piercing_arrow_unlocked: bool = false
@export var explosive_arrow_unlocked: bool = false
@export var rapid_fire_unlocked: bool = false
@export var rain_of_arrows_unlocked: bool = false

func is_unlocked(skill_name: StringName) -> bool:
	match skill_name:
		&"power_shot": return power_shot_unlocked
		&"multi_shot": return multi_shot_unlocked
		&"piercing_arrow": return piercing_arrow_unlocked
		&"explosive_arrow": return explosive_arrow_unlocked
		&"rapid_fire": return rapid_fire_unlocked
		&"rain_of_arrows": return rain_of_arrows_unlocked
		_: return false
