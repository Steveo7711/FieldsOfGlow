extends Node

const SAVE_PATH: String = "user://savegame.json"

var inventory: Dictionary = {}
var spirit_data: Dictionary = {}
var crop_states: Dictionary = {}
var last_save_timestamp: int = 0

func add_resource(resource_id: String, amount: int) -> void:
	if not inventory.has(resource_id):
		inventory[resource_id] = 0
	inventory[resource_id] += amount

func get_resource(resource_id: String) -> int:
	return inventory.get(resource_id, 0)

func save() -> void:
	last_save_timestamp = Time.get_unix_time_from_system()
	var data = {
		"inventory": inventory,
		"spirit_data": spirit_data,
		"crop_states": crop_states,
		"timestamp": last_save_timestamp,
		"day": TimeManager.current_day,
		"hour": TimeManager.current_hour,
	}
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()

func load() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	if data:
		inventory = data.get("inventory", {})
		spirit_data = data.get("spirit_data", {})
		crop_states = data.get("crop_states", {})
		last_save_timestamp = data.get("timestamp", 0)
