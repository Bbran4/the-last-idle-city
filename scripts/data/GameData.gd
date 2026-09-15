class_name GameData
extends Resource

const STARTING_ENERGY: float = 0.0

## --- Population & Workforce ---
const STARTING_POPULATION: float = 100.0
const POPULATION_GROWTH_PER_SECOND: float = 1.0
const WORKFORCE_RATE: float = 0.5

## --- Department allocation efficiency curve ---
## Red -> Orange -> Green -> Orange -> Red, per the README. The green
## zone is the efficient range; efficiency tapers linearly outside it
## down to a floor instead of collapsing to zero, so bad allocation is
## costly but never a total shutdown.
const ALLOCATION_EFFICIENT_MIN: float = 40.0
const ALLOCATION_EFFICIENT_MAX: float = 60.0
const ALLOCATION_MIN_EFFICIENCY: float = 0.25

var materials: BigNumber
var total_materials_produced: BigNumber

@export var energy: float = STARTING_ENERGY
@export var population: float = STARTING_POPULATION
## Percent (0-100) of available workforce assigned to the Industrial
## Authority (drives the Materials department). The remainder is
## implicitly assigned to the Central Government (drives the Energy
## department). More departments will subdivide this further later.
@export var industrial_authority_allocation: float = 50.0
@export var game_time: float = 0.0
@export var total_ticks: int = 0

func _init() -> void:
	materials = BigNumber.zero()
	total_materials_produced = BigNumber.zero()

func produce_materials(amount: BigNumber) -> void:
	materials = materials.add(amount)
	total_materials_produced = total_materials_produced.add(amount)

## --- Population & Workforce ---

func process_population(delta: float) -> void:
	population += POPULATION_GROWTH_PER_SECOND * delta

func available_workforce() -> float:
	return population * WORKFORCE_RATE

func industrial_authority_workforce() -> float:
	return available_workforce() * (industrial_authority_allocation / 100.0)

func central_government_allocation() -> float:
	return 100.0 - industrial_authority_allocation

func central_government_workforce() -> float:
	return available_workforce() * (central_government_allocation() / 100.0)

func set_industrial_authority_allocation(value: float) -> void:
	industrial_authority_allocation = clamp(value, 0.0, 100.0)

## Shared efficiency curve used by every department allocation. 1.0
## inside the efficient range, tapering linearly down to
## ALLOCATION_MIN_EFFICIENCY at the extremes (0% or 100%).
func _allocation_efficiency(allocation_percent: float) -> float:
	if allocation_percent >= ALLOCATION_EFFICIENT_MIN and allocation_percent <= ALLOCATION_EFFICIENT_MAX:
		return 1.0

	var distance: float
	if allocation_percent < ALLOCATION_EFFICIENT_MIN:
		distance = ALLOCATION_EFFICIENT_MIN - allocation_percent
	else:
		distance = allocation_percent - ALLOCATION_EFFICIENT_MAX

	var max_distance: float = max(ALLOCATION_EFFICIENT_MIN, 100.0 - ALLOCATION_EFFICIENT_MAX)
	var t: float = clamp(distance / max_distance, 0.0, 1.0)
	return lerp(1.0, ALLOCATION_MIN_EFFICIENCY, t)

func industrial_authority_efficiency() -> float:
	return _allocation_efficiency(industrial_authority_allocation)

func central_government_efficiency() -> float:
	return _allocation_efficiency(central_government_allocation())

func allocation_zone_name(allocation_percent: float) -> String:
	if allocation_percent >= ALLOCATION_EFFICIENT_MIN and allocation_percent <= ALLOCATION_EFFICIENT_MAX:
		return "GREEN"
	var distance: float
	if allocation_percent < ALLOCATION_EFFICIENT_MIN:
		distance = ALLOCATION_EFFICIENT_MIN - allocation_percent
	else:
		distance = allocation_percent - ALLOCATION_EFFICIENT_MAX
	return "ORANGE" if distance <= 25.0 else "RED"

## --- Energy (aggregated across every registered Department) ---

func energy_consumption_per_second() -> float:
	var total := 0.0
	for department in GameState.departments:
		total += department.energy_consumption_per_second()
	return total

func energy_production_per_second() -> float:
	var total := 0.0
	for department in GameState.departments:
		total += department.energy_production_per_second()
	return total

func energy_balance_per_second() -> float:
	return energy_production_per_second() - energy_consumption_per_second()

## Ratio of current Energy demand actually being met (1.0 = fully
## powered, down to 0.0 = blackout for power-hungry automation). This
## is what throttles power-hungry automation instead of the game
## hard-stopping when Energy runs short (the README's "load-shedding").
func power_supply_ratio() -> float:
	var demand := energy_consumption_per_second()
	if demand <= 0.0:
		return 1.0
	return clamp(energy_production_per_second() / demand, 0.0, 1.0)

func is_energy_shortage() -> bool:
	return power_supply_ratio() < 1.0

func process_energy(delta: float) -> void:
	energy = max(0.0, energy + energy_balance_per_second() * delta)

func process(delta: float) -> void:
	game_time += delta
	total_ticks += 1
	process_population(delta)
	process_energy(delta)
	for department in GameState.departments:
		department.process(delta)
