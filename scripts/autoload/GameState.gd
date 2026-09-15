extends Node

var data: GameData

## Every Department node in the scene registers itself here on _ready(),
## so GameData can sum Energy production/consumption across whichever
## departments exist without needing a direct reference to each one.
var departments: Array[Department] = []


func _ready() -> void:
	data = GameData.new()


func register_department(department: Department) -> void:
	if not departments.has(department):
		departments.append(department)


func unregister_department(department: Department) -> void:
	departments.erase(department)


func get_department(lookup_name: String) -> Department:
	for department in departments:
		if department.department_name == lookup_name:
			return department
	return null


func reset_game() -> void:
	data = GameData.new()
	for department in departments:
		department.reset()
