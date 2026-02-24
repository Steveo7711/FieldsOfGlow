class_name MutationTracker
extends Node

var assigned_traits: Array[String] = []
var has_mutated: bool = false

func check_for_mutation(light_history: Array, mutation_chance: float) -> String:
	if has_mutated:
		return ""
	
	if randf() > mutation_chance:
		return ""
	
	var mutation = _determine_mutation(light_history)
	if mutation != "":
		has_mutated = true
		assigned_traits.append(mutation)
		EventBus.crop_mutated.emit(get_parent().crop_data.crop_id, mutation)
	
	return mutation

func _determine_mutation(light_history: Array) -> String:
	if light_history.is_empty():
		return ""
	
	var warm_count = 0
	var cool_count = 0
	
	for entry in light_history:
		var color: Color = entry["color"]
		if color.r > color.b:
			warm_count += 1
		else:
			cool_count += 1
	
	if warm_count > cool_count:
		return "sun_kissed"
	elif cool_count > warm_count:
		return "moon_touched"
	else:
		return "balanced_growth"

func reset() -> void:
	assigned_traits.clear()
	has_mutated = false
