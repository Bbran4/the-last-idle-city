class_name SkillManager
extends Node

signal skill_choices_ready(skill_names: Array[String])
signal skill_acquired(skill_name: String)

const SKILLS: Array[String] = [
	"Power Shot",
	"Multi Shot",
	"Piercing Arrow",
	"Explosive Arrow",
	"Rapid Fire",
	"Rain of Arrows"
]

var owned_skills: Array[String] = []
var current_choices: Array[String] = []

func setup(wave_manager: WaveManager) -> void:
	owned_skills.clear()
	current_choices.clear()
	if wave_manager and not wave_manager.intermission_started.is_connected(_on_intermission_started):
		wave_manager.intermission_started.connect(_on_intermission_started)

func _exit_tree() -> void:
	var wave_manager := get_node_or_null("../WaveManager") as WaveManager
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
	return true

func has_skill(skill_name: String) -> bool:
	return owned_skills.has(skill_name)

func get_owned_skills() -> Array[String]:
	return owned_skills.duplicate()
