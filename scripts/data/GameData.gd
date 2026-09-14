class_name GameData
extends Resource

@export var materials: float = 0.0
@export var scrap_yard_level: int = 1
@export var game_time: float = 0.0
@export var total_ticks: int = 0


func scrap_yard_production_per_second() -> float:
	return float(scrap_yard_level)


func scrap_yard_level_up_cost() -> float:
	return 10.0 * pow(1.15, scrap_yard_level - 1)


func can_level_up_scrap_yard() -> bool:
	return materials >= scrap_yard_level_up_cost()


func level_up_scrap_yard() -> bool:
	if not can_level_up_scrap_yard():
		return false

	materials -= scrap_yard_level_up_cost()
	scrap_yard_level += 1
	return true
