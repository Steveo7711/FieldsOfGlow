extends SpiritBase

const PULSE_SPEED = 2.0
const PULSE_MIN = 0.5
const PULSE_MAX = 1.0

var pulse_timer: float = 0.0

func _process(delta: float) -> void:
	pulse_timer += delta
	# Rhythmic light pulsing
	var pulse = lerp(PULSE_MIN, PULSE_MAX, (sin(pulse_timer * PULSE_SPEED) + 1.0) / 2.0)
	light_emitter.energy = pulse
	
	# Morning favor - stronger in morning hours
	if TimeManager.current_hour >= 6 and TimeManager.current_hour <= 10:
		light_emitter.energy = pulse * 1.5
