class_name ImpUnit
extends Resource

## A quantity-scaling producer in the Underworld Idle style:
## - Owning more units increases production linearly.
## - Crossing a COUNT threshold (not a "level") lets the player pay
##   that many units of ITSELF to double all remaining units' output.
## - Optionally, purchasing a unit can also require consuming a flat
##   count of another ImpUnit (e.g. Imp B requires 100 Imp A).
##
## Milestone thresholds are seeded from the exact numbers given for
## Imp A (10, 54, 576). No published formula for what comes after 576
## was found during research — MILESTONE_GENERATED_GROWTH extrapolates
## from the most recent ratio (576 / 54 ≈ 10.67) as a placeholder.
## ASSUMPTION — replace with real numbers once you have them.
const MILESTONE_LEVELS: Array[int] = [10, 54, 576]
const MILESTONE_GENERATED_GROWTH := 10.6667

@export var display_name := "Unit"
@export var count: int = 0
@export var milestones_triggered: int = 0

## Cost to purchase the (count+1)th unit, in the primary currency
## (Materials/Gems): purchase_base_cost * purchase_cost_growth^count
@export var purchase_base_cost: float = 10.0
@export var purchase_cost_growth: float = 1.07

## Flat souls cost per unit purchased (not geometric — matches
## "Imp A costs 1 soul", "Imp B costs 2 souls" as stated).
@export var soul_cost_per_unit: float = 1.0

## Base production per unit, before the milestone multiplier.
@export var base_production_per_unit: float = 1.0

## If > 0, purchasing this unit also consumes this many units of a
## secondary ImpUnit (e.g. Imp B requires 100 Imp A). Flat, not
## geometric — no data given for whether this scales per purchase.
## ASSUMPTION — confirm before relying on this for a 2nd+ Imp B.
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


## Consumes next_milestone_count() units of itself; doubles future production.
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


func purchase_soul_cost() -> BigNumber:
	return BigNumber.from_float(soul_cost_per_unit)


## secondary_unit is the ImpUnit this purchase draws
## requires_secondary_unit_count from (e.g. Imp A, when buying Imp B).
## Pass null if this unit has no secondary-unit requirement.
func can_purchase(materials: BigNumber, souls: BigNumber, secondary_unit: ImpUnit) -> bool:
	if materials.is_less_than(purchase_cost()) or souls.is_less_than(purchase_soul_cost()):
		return false
	if requires_secondary_unit_count > 0:
		if secondary_unit == null or secondary_unit.count < requires_secondary_unit_count:
			return false
	return true


func purchase(materials: BigNumber, souls: BigNumber, secondary_unit: ImpUnit) -> Dictionary:
	if not can_purchase(materials, souls, secondary_unit):
		return {"materials": materials, "souls": souls, "success": false}

	var cost := purchase_cost()
	var soul_cost := purchase_soul_cost()

	count += 1
	if requires_secondary_unit_count > 0 and secondary_unit != null:
		secondary_unit.count -= requires_secondary_unit_count

	return {
		"materials": materials.subtract(cost),
		"souls": souls.subtract(soul_cost),
		"success": true
	}


func save_data() -> Dictionary:
	return {"count": count, "milestones_triggered": milestones_triggered}


func load_save_data(data: Dictionary) -> void:
	count = max(0, int(data.get("count", 0)))
	milestones_triggered = max(0, int(data.get("milestones_triggered", 0)))
