extends Node2D

@export var field_config: FieldConfig

func _ready() -> void:
	if field_config:
		print("Loaded field: ", field_config.field_name)
	DataManager.load_game()
