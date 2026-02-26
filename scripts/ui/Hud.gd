extends CanvasLayer

@onready var resource_label: Label = $Control/ResourceDisplay/ResourceLabel
@onready var day_label: Label = $Control/TimeDisplay/DayLabel
@onready var time_label: Label = $Control/TimeDisplay/TimeLabel
@onready var harvest_prompt: Label = $Control/HarvestPrompt


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Connect up EventBus 
	EventBus.crop_harvested.connect(_on_crop_harvested)
	EventBus.hour_changed.connect(_on_hour_changed)
	EventBus.day_changed.connect(_on_day_changed)
	EventBus.tick_passed.connect(_on_tick)
	
	#set intials 
	_update_resource_display()
	time_label.text = TimeManager.get_time_string()
	day_label.text = "Day %d" % TimeManager.current_day
	

func _on_crop_harvested(_crop_id, _resource, _amount) -> void:
	_update_resource_display()

func _on_hour_changed(_hour) -> void:
	time_label.text = TimeManager.get_time_string()

func _on_day_changed(day) -> void:
	day_label.text = "Day %d" % day

func _on_tick() -> void:
	_update_resource_display()
	_check_harvest_prompt()

func _update_resource_display() -> void:
	var grain = DataManager.get_resource("grain_bundle")
	var mutated = DataManager.get_resource("mutated_crop")
	resource_label.text = "Grain: %d  |  Mutated: %d" % [grain, mutated]

func _check_harvest_prompt() -> void:
	var crops = get_tree().get_nodes_in_group("crops")
	var player = get_tree().get_first_node_in_group("player")
	
	if not player:
		harvest_prompt.visible = false
		return
	
	for crop in crops:
		var crop_tile = crop as CropTile
		if crop_tile:
			if crop_tile.is_harvestable:
				var distance = player.global_position.distance_to(crop_tile.global_position)
				if distance < 50.0:
					harvest_prompt.visible = true
					return
	
	harvest_prompt.visible = false
