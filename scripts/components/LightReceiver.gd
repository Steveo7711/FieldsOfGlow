class_name LightReceiver
extends Node

var accumulated_light: float = 0.0
var light_history: Array[Dictionary] = []

func _ready() -> void:
	EventBus.tick_passed.connect(_on_tick)

func _on_tick() -> void:
	var spirits_in_range = _get_spirits_in_range()
	
	if spirits_in_range.size() > 0:
		for spirit in spirits_in_range:
			var light_value = _calculate_light_value(spirit)
			accumulated_light += light_value

			light_history.append({
				"color": spirit.spirit_data.light_color,
				"intensity": spirit.spirit_data.light_intensity,
			})
			
			if light_history.size() > 20:
				light_history.pop_front()

func _get_spirits_in_range() -> Array:
	var crop_tile = get_parent() as Area2D
	if not crop_tile:
		return []
	var overlapping = crop_tile.get_overlapping_bodies()
	var spirits = []
	for body in overlapping:
		if body.is_in_group("spirits"):
			spirits.append(body)
	return spirits

func _calculate_light_value(spirit: SpiritBase) -> float:
	if not spirit.spirit_data:
		return 0.0
	
	var base_value = spirit.spirit_data.light_intensity
	
	var crop_tile = get_parent()
	if crop_tile.crop_data:
		var color_match = spirit.spirit_data.light_color.v
		base_value *= (0.5 + color_match * 0.5)
	
	return base_value

func reset() -> void:
	accumulated_light = 0.0
	light_history.clear()
