extends Area2D

@export var target_field: String = "Field2"
@export var requires_item: String = ""

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	
	# Check if transition requires an item
	if requires_item != "":
		if not DataManager.has_item(requires_item):
			print("Need: ", requires_item, " to unlock this area")
			return
	
	print("Transitioning to: ", target_field)
	DataManager.save()
	get_tree().change_scene_to_file("res://scenes/fields/" + target_field + ".tscn")
