extends Node

signal stat_levelled_up(stat_name: String, new_level: int)

const STARTING_LEVEL: int = 1
const BASE_XP_TO_LEVEL: int = 100
const XP_GROWTH_PER_LEVEL: int = 25
const MAX_LEVEL: int = 100
const STRENGTH_XP_PER_FULL_DRAW: int = 10
const MINIMUM_STRENGTH_DRAW_RATIO: float = 0.60
const ACCURACY_XP_MAX: int = 25
const ACCURACY_XP_MAX_DISTANCE: float = 1000.0
const STRENGTH_LAUNCH_SPEED_PER_LEVEL: float = 10.0

var strength_level: int = STARTING_LEVEL
var strength_xp: int = 0
var accuracy_level: int = STARTING_LEVEL
var accuracy_xp: int = 0

func _ready() -> void:
	var data: Dictionary = SaveGame.load_data()
	strength_level = clamp(int(data.get("strength_level", STARTING_LEVEL)), STARTING_LEVEL, MAX_LEVEL)
	strength_xp = max(0, int(data.get("strength_xp", 0)))
	accuracy_level = clamp(int(data.get("accuracy_level", STARTING_LEVEL)), STARTING_LEVEL, MAX_LEVEL)
	accuracy_xp = max(0, int(data.get("accuracy_xp", 0)))

func award_strength_release_xp(draw_ratio: float, xp_multiplier: float = 1.0) -> int:
	var ratio: float = clampf(draw_ratio, 0.0, 1.0)
	if ratio < MINIMUM_STRENGTH_DRAW_RATIO or strength_level >= MAX_LEVEL:
		return 0
	var quality: float = (ratio - MINIMUM_STRENGTH_DRAW_RATIO) / (1.0 - MINIMUM_STRENGTH_DRAW_RATIO)
	var awarded: int = max(1, roundi(quality * STRENGTH_XP_PER_FULL_DRAW * max(xp_multiplier, 1.0)))
	_add_strength_xp(awarded)
	return awarded

func award_accuracy_hit_xp(distance: float, xp_multiplier: float = 1.0) -> int:
	if accuracy_level >= MAX_LEVEL:
		return 0
	var distance_ratio: float = clampf(distance / ACCURACY_XP_MAX_DISTANCE, 0.0, 1.0)
	var awarded := max(1, roundi(distance_ratio * ACCURACY_XP_MAX * max(xp_multiplier, 1.0)))
	_add_accuracy_xp(awarded)
	return awarded

func get_max_launch_speed(base_speed: float) -> float:
	return base_speed + float(strength_level - 1) * STRENGTH_LAUNCH_SPEED_PER_LEVEL
func strength_xp_to_next_level() -> int:
	return BASE_XP_TO_LEVEL + (strength_level - 1) * XP_GROWTH_PER_LEVEL
func accuracy_xp_to_next_level() -> int:
	return BASE_XP_TO_LEVEL + (accuracy_level - 1) * XP_GROWTH_PER_LEVEL
func strength_progress_ratio() -> float:
	return float(strength_xp) / float(strength_xp_to_next_level())
func accuracy_progress_ratio() -> float:
	return float(accuracy_xp) / float(accuracy_xp_to_next_level())

func _add_strength_xp(amount: int) -> void:
	strength_xp += amount
	while strength_level < MAX_LEVEL and strength_xp >= strength_xp_to_next_level():
		strength_xp -= strength_xp_to_next_level()
		strength_level += 1
		stat_levelled_up.emit("STRENGTH", strength_level)
	_save()

func _add_accuracy_xp(amount: int) -> void:
	accuracy_xp += amount
	while accuracy_level < MAX_LEVEL and accuracy_xp >= accuracy_xp_to_next_level():
		accuracy_xp -= accuracy_xp_to_next_level()
		accuracy_level += 1
		stat_levelled_up.emit("ACCURACY", accuracy_level)
	_save()

func _save() -> void:
	var data: Dictionary = SaveGame.load_data()
	data["strength_level"] = strength_level
	data["strength_xp"] = strength_xp
	data["accuracy_level"] = accuracy_level
	data["accuracy_xp"] = accuracy_xp
	SaveGame.save_data(data)
