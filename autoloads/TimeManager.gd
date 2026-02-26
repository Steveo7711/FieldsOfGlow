extends Node

const TICK_INTERVAL: float = 30.0
const TICKS_PER_HOUR: int = 2
const HOURS_PER_DAY: int = 24
const MAX_OFFLINE_TICKS: int = 960

var current_tick: int = 0
var current_hour: int = 6
var current_day: int = 1
var _tick_accumulator: float = 0.0
var is_running: bool = true

func _ready() -> void:
	_check_offline_progress()

func _check_offline_progress() -> void:
	var last_timestamp = DataManager.last_save_timestamp
	if last_timestamp == 0:
		return
	
	var current_timestamp = Time.get_unix_time_from_system()
	var seconds_away = current_timestamp - last_timestamp
	
	if seconds_away < 60:
		return
	
	print("Away for: ", seconds_away, " seconds")
	
	var ticks_passed = int(seconds_away / TICK_INTERVAL)
	ticks_passed = min(ticks_passed, MAX_OFFLINE_TICKS)
	
	print("Simulating ", ticks_passed, " offline ticks")
	
	var summary = await _simulate_offline_ticks(ticks_passed, seconds_away)
	
	await get_tree().create_timer(1.5).timeout
	EventBus.afk_return_ready.emit(summary)

func _simulate_offline_ticks(ticks: int, seconds_away: int) -> Dictionary:
	var crops_grown = 0
	var mutations = 0
	var harvestable_count = 0
	
	for i in range(ticks):
		current_tick += 1
		if current_tick % TICKS_PER_HOUR == 0:
			current_hour = (current_hour + 1) % HOURS_PER_DAY
			if current_hour == 0:
				current_day += 1
	
	var crops = get_tree().get_nodes_in_group("crops")
	for crop in crops:
		var crop_tile = crop as CropTile
		if not crop_tile or not crop_tile.crop_data:
			continue
		if not crop_tile.light_receiver:
			continue
		
		var avg_light_per_tick = crop_tile.crop_data.base_growth_ticks * 0.05
		var total_light = avg_light_per_tick * ticks
		var stages_grown = int(total_light / crop_tile.crop_data.base_growth_ticks)
		
		for s in range(stages_grown):
			if not crop_tile.is_harvestable:
				crop_tile.current_stage += 1
				crops_grown += 1
				
				if randf() < crop_tile.crop_data.mutation_chance:
					mutations += 1
					DataManager.add_resource("mutated_crop", 1)
				
				if crop_tile.current_stage >= crop_tile.crop_data.growth_stages:
					crop_tile.is_harvestable = true
		
		if crop_tile.is_harvestable:
			harvestable_count += 1
		
		crop_tile.save_state()
	
	DataManager.save_game()
	
	return {
		"seconds_away": seconds_away,
		"ticks_simulated": ticks,
		"crops_grown": crops_grown,
		"mutations": mutations,
		"harvestable_count": harvestable_count,
	}

func _process(delta: float) -> void:
	if not is_running:
		return
	_tick_accumulator += delta
	if _tick_accumulator >= TICK_INTERVAL:
		_tick_accumulator -= TICK_INTERVAL
		_on_tick()

func _on_tick() -> void:
	current_tick += 1
	EventBus.tick_passed.emit()
	
	if current_tick % TICKS_PER_HOUR == 0:
		current_hour = (current_hour + 1) % HOURS_PER_DAY
		EventBus.hour_changed.emit(current_hour)
		DataManager.save_game()
		
		if current_hour == 0:
			current_day += 1
			EventBus.day_changed.emit(current_day)

func pause() -> void:
	is_running = false

func resume() -> void:
	is_running = true

func get_time_string() -> String:
	var suffix = "AM" if current_hour < 12 else "PM"
	var display_hour = current_hour % 12
	if display_hour == 0:
		display_hour = 12
	return "%d:00 %s" % [display_hour, suffix]
