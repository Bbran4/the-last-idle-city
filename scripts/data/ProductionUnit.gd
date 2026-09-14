class_name ProductionUnit
extends Resource

## A quantity-scaling production unit.
##
## Units run alongside the building production chain. Higher-tier units
## can generate lower-tier units, while milestone thresholds consume units
## from the current tier to permanently increase its remaining output.
const MILESTONE_LEVELS: Array[int] = [10, 54, 576]
const MILESTONE_GENERATED_GROWTH := 10.6667

@export var display_name := "Unit"
@export var count: int = 0
@export var milestones_triggered: int = 0
@export var purchase_base_cost: float = 10.0
@export var purchase_cost_growth: float = 1.07
@export var base_production_per_unit: float = 1.0
@export var requires_secondary_unit_count: int = 0


static func milestone_level_at(index: int) -> int:
	if index < MILESTONE_LEVELS.size():
		return MILESTONE_LEVELS[index]
	var generated_steps := index - (MILESTONE_LEVELS.size() - 1)
	var last_defined := MILESTONE_LEVELS[MILESTONE_LEVELS.size() - 1]
	return int(round(last_defined * pow(MILESTONE_GENERATED_GROWTH, generated_steps)))


func next_milestone_count() -> int:
	return milestone_level_at(milestones_triggered)


func can_trigger_milestone() -> bool:
	return count >= next_milestone_count()


func trigger_milestone() -> bool:
	if not can_trigger_milestone():
		return false
	count -= next_milestone_count()
	milestones_triggered += 1
	return true


func milestone_multiplier() -> BigNumber:
	return BigNumber.from_float(2.0).pow_int(milestones_triggered)


func production_per_second() -> BigNumber:
	return BigNumber.from_float(base_production_per_unit * float(count)).multiply(milestone_multiplier())


func purchase_cost() -> BigNumber:
	return BigNumber.from_float(purchase_base_cost).multiply(
		BigNumber.from_float(purchase_cost_growth).pow_int(count)
	)


func can_purchase(materials: BigNumber, secondary_unit: ProductionUnit) -> bool:
	if materials.is_less_than(purchase_cost()):
		return false
	if requires_secondary_unit_count > 0:
		if secondary_unit == null or secondary_unit.count < requires_secondary_unit_count:
			return false
	return true


func purchase(materials: BigNumber, secondary_unit: ProductionUnit) -> Dictionary:
	if not can_purchase(materials, secondary_unit):
		return {"materials": materials, "success": false}

	var cost := purchase_cost()
	count += 1
	if requires_secondary_unit_count > 0 and secondary_unit != null:
		secondary_unit.count -= requires_secondary_unit_count

	return {
		"materials": materials.subtract(cost),
		"success": true
	}


func save_data() -> Dictionary:
	return {"count": count, "milestones_triggered": milestones_triggered}


func load_save_data(data: Dictionary) -> void:
	count = max(0, int(data.get("count", 0)))
	milestones_triggered = max(0, int(data.get("milestones_triggered", 0)))
