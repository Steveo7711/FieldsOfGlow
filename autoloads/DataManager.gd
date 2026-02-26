extends Node

const SAVE_PATH: String = "user://savegame.json"

var inventory: Dictionary = {}
var spirit_registry: Dictionary = {}
var crop_states: Dictionary = {}
var last_save_timestamp: int = 0
var unlocked_fields: Array[String] = ["field1"]

func _ready() -> void:
	load_game()

func add_resource(resource_id: String, amount: int) -> void:
	if not inventory.has(resource_id):
		inventory[resource_id] = 0
	inventory[resource_id] += amount

func get_resource(resource_id: String) -> int:
	return inventory.get(resource_id, 0)

func has_item(item_id: String) -> bool:
	return inventory.get(item_id, 0) > 0

func unlock_field(field_id: String) -> void:
	if not unlocked_fields.has(field_id):
		unlocked_fields.append(field_id)
		print("Field unlocked: ", field_id)
		save_game()

func is_field_unlocked(field_id: String) -> bool:
	return unlocked_fields.has(field_id)

func save_crop_state(crop_id: String, stage: int, accumulated: float, harvestable: bool) -> void:
	crop_states[crop_id] = {
		"stage": stage,
		"accumulated": accumulated,
		"harvestable": harvestable
	}

func get_crop_state(crop_id: String) -> Dictionary:
	return crop_states.get(crop_id, {})

func save_game() -> void:
	last_save_timestamp = Time.get_unix_time_from_system()
	var data = {
		"inventory": inventory,
		"crop_states": crop_states,
		"unlocked_fields": unlocked_fields,
		"timestamp": last_save_timestamp,
		"day": TimeManager.current_day,
		"hour": TimeManager.current_hour,
		"tick": TimeManager.current_tick,
	}
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()
		print("Game saved!")
	else:
		print("Save failed!")

func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		print("No save file found - fresh start")
		return
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		print("Could not open save file")
		return
	
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	
	if not data:
		print("Save file corrupted")
		return
	
	inventory = data.get("inventory", {})
	crop_states = data.get("crop_states", {})
	
	var loaded_fields = data.get("unlocked_fields", ["field1"])
	unlocked_fields.clear()
	for field in loaded_fields:
		unlocked_fields.append(str(field))
	
	last_save_timestamp = data.get("timestamp", 0)
	TimeManager.current_day = data.get("day", 1)
	TimeManager.current_hour = data.get("hour", 6)
	TimeManager.current_tick = data.get("tick", 0)
	
	print("Game loaded! Day: ", TimeManager.current_day, " Hour: ", TimeManager.current_hour)
