class_name PlayerStats
extends RefCounted

## Central player stat progression.
## Strength improves physical output through draw/release practice.
## Accuracy improves through bullseyes and will power aim assistance later.

const STARTING_LEVEL: int = 1
const BASE_XP_TO_LEVEL: int = 100
const XP_GROWTH_PER_LEVEL: int = 25
const MAX_LEVEL: int = 100

const STRENGTH_XP_PER_FULL_DRAW: int = 25
const MINIMUM_STRENGTH_DRAW_RATIO: float = 0.60
const ACCURACY_XP_PER_BULLSEYE: int = 50

var strength_level: int = STARTING_LEVEL
var strength_xp: int = 0
var accuracy_level: int = STARTING_LEVEL
var accuracy_xp: int = 0

func award_strength_release_xp(draw_ratio: float) -> int:
	var ratio: float = clamp(draw_ratio, 0.0, 1.0)
	if ratio < MINIMUM_STRENGTH_DRAW_RATIO or strength_level >= MAX_LEVEL:
		return 0

	var quality: float = (ratio - MINIMUM_STRENGTH_DRAW_RATIO) / (1.0 - MINIMUM_STRENGTH_DRAW_RATIO)
	var awarded: int = max(1, roundi(quality * STRENGTH_XP_PER_FULL_DRAW))
	_add_strength_xp(awarded)
	return awarded

func award_accuracy_bullseye_xp() -> int:
	if accuracy_level >= MAX_LEVEL:
		return 0

	_add_accuracy_xp(ACCURACY_XP_PER_BULLSEYE)
	return ACCURACY_XP_PER_BULLSEYE

func _add_strength_xp(amount: int) -> void:
	strength_xp += amount
	while strength_level < MAX_LEVEL and strength_xp >= strength_xp_to_next_level():
		strength_xp -= strength_xp_to_next_level()
		strength_level += 1

func _add_accuracy_xp(amount: int) -> void:
	accuracy_xp += amount
	while accuracy_level < MAX_LEVEL and accuracy_xp >= accuracy_xp_to_next_level():
		accuracy_xp -= accuracy_xp_to_next_level()
		accuracy_level += 1

func strength_xp_to_next_level() -> int:
	return BASE_XP_TO_LEVEL + (strength_level - 1) * XP_GROWTH_PER_LEVEL

func accuracy_xp_to_next_level() -> int:
	return BASE_XP_TO_LEVEL + (accuracy_level - 1) * XP_GROWTH_PER_LEVEL

func strength_progress_ratio() -> float:
	return float(strength_xp) / float(strength_xp_to_next_level())

func accuracy_progress_ratio() -> float:
	return float(accuracy_xp) / float(accuracy_xp_to_next_level())

func get_max_launch_speed(base_speed: float) -> float:
	return base_speed + float(strength_level - 1) * 25.0

## Reserved for Milestone 7. Accuracy will improve trajectory prediction,
## not automatically steer the bow or arrow.
func get_aim_assist_strength() -> float:
	if accuracy_level <= 1:
		return 0.0
	return clamp(float(accuracy_level - 1) / 20.0, 0.0, 1.0)
