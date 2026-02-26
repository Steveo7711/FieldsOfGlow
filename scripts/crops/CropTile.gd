class_name CropTile
extends Area2D

@export var crop_data: CropData

@onready var crop_visual: AnimatedSprite2D = $CropVisual
@onready var light_receiver: LightReceiver = $LightReceiver
@onready var mutation_tracker: MutationTracker = $MutationTracker

const GROWTH_CHECK_INTERVAL: int = 1

var current_stage: int = 0
var is_harvestable: bool = false
var ticks_since_check: int = 0

func _ready() -> void:
	add_to_group("crops")
	EventBus.tick_passed.connect(_on_tick)

func _on_tick() -> void:
	if is_harvestable:
		return
	
	ticks_since_check += 1
	if ticks_since_check < GROWTH_CHECK_INTERVAL:
		return
	ticks_since_check = 0
	
	_check_growth()

func _check_growth() -> void:
	if not crop_data:
		return
	
	var threshold = crop_data.base_growth_ticks
	
	if light_receiver.accumulated_light >= threshold:
		_advance_stage()
		light_receiver.accumulated_light = 0.0
		
		var mutation = mutation_tracker.check_for_mutation(
			light_receiver.light_history,
			crop_data.mutation_chance
		)
		if mutation != "":
			DataManager.add_resource("mutated_crop", 1)


func _advance_stage() -> void:
	current_stage += 1
	EventBus.crop_grew.emit(crop_data.crop_id, current_stage)

	
	if current_stage >= crop_data.growth_stages:
		is_harvestable = true


func harvest() -> String:
	if not is_harvestable:
		return ""
	
	var resource = crop_data.yield_resource
	DataManager.add_resource(resource, 1)
	EventBus.crop_harvested.emit(crop_data.crop_id, resource, 1)
	print("Harvested: ", resource)
	
	current_stage = 0
	is_harvestable = false
	light_receiver.reset()
	mutation_tracker.reset()
	
	return resource

func get_growth_progress() -> float:
	if not crop_data:
		return 0.0
	return light_receiver.accumulated_light / crop_data.base_growth_ticks
