class_name StrengthProgression
extends RefCounted

## Simple practice-based Strength progression.
## Strength XP is awarded once per valid arrow release, not every frame.
## Weak releases provide no XP, which prevents rapid low-effort clicking from
## becoming an efficient progression strategy.

const STARTING_LEVEL: int = 1
const BASE_XP_TO_LEVEL: int = 100
const XP_PER_FULL_DRAW: int = 25
const MINIMUM_XP_DRAW_RATIO: float = 0.60
const MAX_STRENGTH_LEVEL: int = 100

var level: int = STARTING_LEVEL
var xp: int = 0

func award_release_xp(draw_ratio: float) -> int:
	var ratio: float = clamp(draw_ratio, 0.0, 1.0)
	if ratio < MINIMUM_XP_DRAW_RATIO or level >= MAX_STRENGTH_LEVEL:
		return 0

	# Scale XP from 1 at the minimum valid release to 25 at full draw.
	var quality: float = (ratio - MINIMUM_XP_DRAW_RATIO) / (1.0 - MINIMUM_XP_DRAW_RATIO)
	var awarded: int = max(1, roundi(quality * XP_PER_FULL_DRAW))
	_add_xp(awarded)
	return awarded

func _add_xp(amount: int) -> void:
	if amount <= 0:
		return

	xp += amount
	while level < MAX_STRENGTH_LEVEL and xp >= xp_to_next_level():
		xp -= xp_to_next_level()
		level += 1

func xp_to_next_level() -> int:
	return BASE_XP_TO_LEVEL + (level - 1) * 25

func xp_progress_ratio() -> float:
	return float(xp) / float(xp_to_next_level())

func get_max_launch_speed(base_speed: float) -> float:
	# Strength increases physical output without changing aim or accuracy.
	return base_speed + float(level - 1) * 25.0
