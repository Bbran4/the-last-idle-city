class_name BowInventory
extends RefCounted

const STARTING_BOW_ID: String = "training_bow"

var bows: Dictionary = {}
var owned: Dictionary = {}
var equipped_bow_id: String = STARTING_BOW_ID

func _init() -> void:
	_register_defaults()
	owned[STARTING_BOW_ID] = true

func _register_defaults() -> void:
	bows["training_bow"] = BowData.new("training_bow", "Training Bow", 0, 1, 100.0, 55.0, 360.0, 760.0, "Reliable and forgiving.")
	bows["recurve_bow"] = BowData.new("recurve_bow", "Recurve Bow", 350, 2, 110.0, 65.0, 410.0, 860.0, "Faster draw with stronger launch power.")
	bows["war_bow"] = BowData.new("war_bow", "War Bow", 900, 5, 125.0, 45.0, 470.0, 980.0, "Heavy draw and excellent range.")

func get_equipped() -> BowData:
	return bows[equipped_bow_id]

func get_bow(bow_id: String) -> BowData:
	return bows.get(bow_id, null)

func is_owned(bow_id: String) -> bool:
	return owned.get(bow_id, false)

func can_purchase(bow_id: String, money: int, strength_level: int) -> bool:
	var bow: BowData = get_bow(bow_id)
	return bow != null and not is_owned(bow_id) and strength_level >= bow.required_strength and money >= bow.price

func purchase(bow_id: String, money: int, strength_level: int) -> int:
	var bow: BowData = get_bow(bow_id)
	if not can_purchase(bow_id, money, strength_level):
		return -1
	owned[bow_id] = true
	return bow.price

func can_equip(bow_id: String, strength_level: int) -> bool:
	var bow: BowData = get_bow(bow_id)
	return bow != null and is_owned(bow_id) and strength_level >= bow.required_strength

func equip(bow_id: String, strength_level: int) -> bool:
	if not can_equip(bow_id, strength_level):
		return false
	equipped_bow_id = bow_id
	return true
