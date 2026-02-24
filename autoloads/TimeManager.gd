extends Node

const TICK_INTERVAL: float = 3.0
const TICKS_PER_HOUR: int = 2
const HOURS_PER_DAY: int = 24

var current_tick: int = 0
var current_hour: int = 6
var current_day: int = 1
var _tick_accumulator: float = 0.0
var is_running: bool = true

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
