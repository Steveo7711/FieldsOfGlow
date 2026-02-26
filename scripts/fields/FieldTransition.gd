extends Area2D

@export var target_field: String = "Field2"
@export var requires_item: String = ""

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	
	if requires_item != "":
		if not DataManager.has_item(requires_item):
			print("Need: ", requires_item, " to unlock this area")
			return
	
	DataManager.unlock_field(target_field.to_lower())
	DataManager.save_game()
	
	print("Transitioning to: ", target_field)
	get_tree().change_scene_to_file("res://scenes/fields/" + target_field + ".tscn")
