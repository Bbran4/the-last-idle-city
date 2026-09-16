class_name BowInventory
extends RefCounted

const STARTING_BOW_ID: String = "training_bow"
const BOW_RESOURCE_PATHS: Array[String] = [
	"res://resources/bows/training_bow.tres",
	"res://resources/bows/recurve_bow.tres",
	"res://resources/bows/war_bow.tres"
]

var bows: Dictionary = {}
var owned: Dictionary = {}
var equipped_bow_id: String = STARTING_BOW_ID

func _init() -> void:
	_load_bow_resources()
	owned[STARTING_BOW_ID] = true

func _load_bow_resources() -> void:
	for resource_path: String in BOW_RESOURCE_PATHS:
		var bow: BowData = load(resource_path) as BowData
		if bow == null or bow.id.is_empty():
			push_error("Unable to load bow resource: %s" % resource_path)
			continue
		bows[bow.id] = bow

func get_equipped() -> BowData:
	return bows.get(equipped_bow_id, null)

func get_bow(bow_id: String) -> BowData:
	return bows.get(bow_id, null)

func get_all_bows() -> Array[BowData]:
	var result: Array[BowData] = []
	for bow_id: String in bows:
		result.append(bows[bow_id])
	return result

func is_owned(bow_id: String) -> bool:
	return owned.get(bow_id, false)

func can_purchase(bow_id: String, money: int, strength_level: int) -> bool:
	var bow: BowData = get_bow(bow_id)
	return bow != null and not is_owned(bow_id) and strength_level >= bow.required_strength and money >= bow.price

func unlock(bow_id: String) -> bool:
	var bow: BowData = get_bow(bow_id)
	if bow == null or is_owned(bow_id):
		return false
	owned[bow_id] = true
	return true

func can_equip(bow_id: String, strength_level: int) -> bool:
	var bow: BowData = get_bow(bow_id)
	return bow != null and is_owned(bow_id) and strength_level >= bow.required_strength

func equip(bow_id: String, strength_level: int) -> bool:
	if not can_equip(bow_id, strength_level):
		return false
	equipped_bow_id = bow_id
	return true
