extends Node

const TICK_INTERVAL: float = 30.0  # real seconds per game tick
const TICKS_PER_HOUR: int = 2
const HOURS_PER_DAY: int = 24

var current_tick: int = 0
var current_hour: int = 6  # start at 6am
var current_day: int = 1
var _tick_accumulator: float = 0.0

func _process(delta: float) -> void:
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
