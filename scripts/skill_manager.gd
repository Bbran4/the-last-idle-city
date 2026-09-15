class_name SkillManager
extends Node

signal skill_choices_ready(skill_names: Array[String])
signal skill_acquired(skill_name: String)
signal power_shot_state_changed(available: bool, cooldown_remaining: float)
signal power_shot_requested

const SKILLS: Array[String] = [
	"Power Shot",
	"Multi Shot",
	"Piercing Arrow",
	"Explosive Arrow",
	"Rapid Fire",
	"Rain of Arrows"
]

const POWER_SHOT_DAMAGE_MULTIPLIER: float = 3.0
const POWER_SHOT_COOLDOWN: float = 10.0

var owned_skills: Array[String] = []
var current_choices: Array[String] = []
var power_shot_cooldown: float = 0.0
var power_shot_armed: bool = false
var wave_manager: WaveManager

func setup(manager: WaveManager) -> void:
	wave_manager = manager
	owned_skills.clear()
	current_choices.clear()
	power_shot_cooldown = 0.0
	power_shot_armed = false
	if wave_manager and not wave_manager.intermission_started.is_connected(_on_intermission_started):
		wave_manager.intermission_started.connect(_on_intermission_started)
	power_shot_state_changed.emit(is_power_shot_available(), power_shot_cooldown)

func _process(delta: float) -> void:
	if power_shot_cooldown > 0.0:
		power_shot_cooldown = maxf(power_shot_cooldown - delta, 0.0)
		if power_shot_cooldown <= 0.0:
			power_shot_state_changed.emit(is_power_shot_available(), 0.0)

func _exit_tree() -> void:
	if wave_manager and wave_manager.intermission_started.is_connected(_on_intermission_started):
		wave_manager.intermission_started.disconnect(_on_intermission_started)

func _on_intermission_started(wave: int, _duration: float) -> void:
	if wave <= 0 or wave % WaveManager.MINI_BOSS_INTERVAL != 0:
		return
	if wave % WaveManager.MAJOR_BOSS_INTERVAL == 0:
		return
	_offer_skill_cards()

func _offer_skill_cards() -> void:
	current_choices.clear()
	var available: Array[String] = []
	for skill_name in SKILLS:
		if not owned_skills.has(skill_name):
			available.append(skill_name)

	if available.is_empty():
		return

	available.shuffle()
	var choice_count := mini(3, available.size())
	for index in choice_count:
		current_choices.append(available[index])

	skill_choices_ready.emit(current_choices.duplicate())

func choose_skill(skill_name: String) -> bool:
	if not current_choices.has(skill_name) or owned_skills.has(skill_name):
		return false

	owned_skills.append(skill_name)
	current_choices.clear()
	skill_acquired.emit(skill_name)
	if skill_name == "Power Shot":
		power_shot_state_changed.emit(true, 0.0)
	return true

func activate_power_shot() -> bool:
	if not has_skill("Power Shot") or power_shot_armed or power_shot_cooldown > 0.0:
		return false
	if not GameState.is_game_active() or wave_manager == null or wave_manager.is_intermission():
		return false

	power_shot_armed = true
	power_shot_cooldown = POWER_SHOT_COOLDOWN
	power_shot_requested.emit()
	power_shot_state_changed.emit(false, power_shot_cooldown)
	return true

func consume_power_shot() -> bool:
	if not power_shot_armed:
		return false
	power_shot_armed = false
	return true

func has_power_shot_armed() -> bool:
	return power_shot_armed

func get_power_shot_cooldown() -> float:
	return power_shot_cooldown

func is_power_shot_available() -> bool:
	return has_skill("Power Shot") and not power_shot_armed and power_shot_cooldown <= 0.0

func has_skill(skill_name: String) -> bool:
	return owned_skills.has(skill_name)

func get_owned_skills() -> Array[String]:
	return owned_skills.duplicate()
