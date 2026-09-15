class_name Department
extends Node

## Base class shared by every production department (Materials, Energy,
## and whatever comes next). A Department owns a set of ProductionOperation
## "buildings" plus the rules for unlocking them, whether their card should
## be visible yet, and any department-specific automation between tiers
## (e.g. the Materials chain's cascading Scrap Yard -> Reclamation Depot ->
## Workshop -> Factory automation).
##
## Concrete departments (MaterialsDepartment, EnergyDepartment, ...) are
## meant to be attached as Node children of the main scene, with their
## initial costs/rates exposed as @export fields so each department can be
## tuned per-instance in the editor instead of buried in one giant script.

## Display name for this department (e.g. "Materials", "Energy"). Also
## used as its save-data key, so keep it stable once you've saved a game.
@export var department_name: String = "Department"

## Whether this department can be interacted with at all yet. Setting
## this to false hides/disables the whole department (every building,
## and its tab in the UI) regardless of individual building costs -
## used for departments that exist in code but aren't meant to be
## reachable by the player yet.
@export var department_unlocked: bool = true

## Ordered list of this department's buildings, in unlock order.
## Populated by the subclass in _init_buildings().
var buildings: Array[ProductionOperation] = []


func _ready() -> void:
	_init_buildings()
	GameState.register_department(self)


## Override in subclasses: construct this department's ProductionOperation
## buildings (using this node's @export cost fields) and populate `buildings`.
func _init_buildings() -> void:
	pass


## Rebuilds this department back to its starting state. Used by
## GameState.reset_game() instead of recreating the node.
func reset() -> void:
	_init_buildings()


## Override in subclasses: any per-tick automation specific to this
## department (e.g. cascading production between tiers). Called once per
## game tick from GameData.process().
func process(_delta: float) -> void:
	pass


## Override in subclasses to keep any always-present buildings (e.g. a
## department's base tier) at their floor level/count.
func ensure_minimums() -> void:
	pass


## Override in subclasses if a building has a prerequisite beyond "the
## department is unlocked and Materials/Energy are sufficient" - e.g.
## Workshop requiring a Reclamation Depot milestone.
func _unlock_requirement_met(_operation: ProductionOperation) -> bool:
	return true


func can_unlock(operation: ProductionOperation) -> bool:
	ensure_minimums()
	if not department_unlocked or operation.unlocked:
		return false
	if not _unlock_requirement_met(operation):
		return false
	if operation.cost_source != null:
		return operation.can_afford_unlock_from_source()
	return GameState.data.materials.is_greater_or_equal(operation.unlock_cost())

func unlock(operation: ProductionOperation) -> bool:
	if not can_unlock(operation):
		return false
	GameState.data.materials = operation.unlock(GameState.data.materials)
	ensure_minimums()
	return true


func can_level_up(operation: ProductionOperation) -> bool:
	ensure_minimums()
	if not department_unlocked or not operation.unlocked:
		return false
	if operation.cost_source != null:
		return operation.can_afford_level_up_from_source() and GameState.data.energy >= operation.level_up_energy_cost
	return GameState.data.materials.is_greater_or_equal(operation.level_up_cost()) and GameState.data.energy >= operation.level_up_energy_cost

func level_up(operation: ProductionOperation) -> bool:
	if not can_level_up(operation):
		return false
	GameState.data.materials = operation.level_up(GameState.data.materials)
	GameState.data.energy -= operation.level_up_energy_cost
	ensure_minimums()
	return true


func can_build_new(operation: ProductionOperation) -> bool:
	ensure_minimums()
	if not department_unlocked:
		return false
	return operation.can_build_new(GameState.data.materials, GameState.data.energy)


func build_new(operation: ProductionOperation) -> bool:
	if not can_build_new(operation):
		return false
	var result: Dictionary = operation.build_new(GameState.data.materials, GameState.data.energy)
	if not bool(result.get("success", false)):
		return false
	GameState.data.materials = result["materials"]
	GameState.data.energy = float(result["energy"])
	ensure_minimums()
	return true

func _level_up_currency(operation: ProductionOperation) -> BigNumber:
	if operation.cost_source != null:
		return BigNumber.from_float(float(operation.cost_source.level))
	return GameState.data.materials

func _downstream_operation(operation: ProductionOperation) -> ProductionOperation:
	for building in buildings:
		if building.cost_source == operation:
			return building
	return null

## How many consecutive Level Ups of `operation` are purchasable right
## now under the given mode ("x1", "next", "max"). "Next" stops once
## `operation`'s level covers the next downstream building's
## unlock/level-up requirement; with no downstream building (end of
## the chain), "next" behaves like "max".
func purchasable_level_ups(operation: ProductionOperation, mode: String) -> int:
	var currency: BigNumber = _level_up_currency(operation)
	var energy: float = GameState.data.energy
	match mode:
		"x1":
			return operation.max_purchasable_levels(currency, energy, 1)
		"max":
			return operation.max_purchasable_levels(currency, energy, -1)
		"next":
			var downstream: ProductionOperation = _downstream_operation(operation)
			if downstream == null:
				return operation.max_purchasable_levels(currency, energy, -1)
			var threshold: BigNumber = downstream.unlock_cost() if not downstream.unlocked else downstream.level_up_cost()
			var target_level: int = int(ceil(threshold.to_float()))
			var cap: int = max(0, target_level - operation.level)
			return operation.max_purchasable_levels(currency, energy, cap)
		_:
			return operation.max_purchasable_levels(currency, energy, 1)

## Purchases up to `count` consecutive Level Ups, stopping early if
## affordability runs out. Returns how many were actually purchased.
func level_up_multiple(operation: ProductionOperation, count: int) -> int:
	var purchased: int = 0
	for i in range(max(1, count)):
		if not level_up(operation):
			break
		purchased += 1
	return purchased

func can_trigger_milestone(operation: ProductionOperation) -> bool:
	ensure_minimums()
	return department_unlocked and operation.can_trigger_milestone()


func trigger_milestone(operation: ProductionOperation) -> bool:
	if not can_trigger_milestone(operation):
		return false
	var result: Dictionary = operation.trigger_milestone()
	ensure_minimums()
	return bool(result.get("success", false))


## A building's card should appear once it's unlocked, or once the
## player has actually earned the right to unlock it (enough Materials
## and any prerequisite met) - instead of sitting there as "LOCKED"
## from the very start of the game.
func is_building_visible(operation: ProductionOperation) -> bool:
	if operation.unlocked:
		return true
	if not department_unlocked:
		return false
	return _unlock_requirement_met(operation) and GameState.data.materials.is_greater_or_equal(operation.unlock_cost())


## Override in subclasses that draw down the shared Energy pool.
func energy_consumption_per_second() -> float:
	return 0.0


## Override in subclasses that add to the shared Energy pool.
func energy_production_per_second() -> float:
	return 0.0


func save_data() -> Dictionary:
	var data: Dictionary = {}
	for building in buildings:
		data[building.display_name] = building.save_data()
	return data


func load_save_data(data: Dictionary) -> void:
	for building in buildings:
		if data.has(building.display_name):
			building.load_save_data(data[building.display_name])
	ensure_minimums()
