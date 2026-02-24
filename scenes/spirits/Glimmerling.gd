extends SpiritBase

const FLICKER_SPEED = 8.0

var flicker_timer: float = 0.0
var flicker_intensity: float = 0.6

func _process(delta: float) -> void:
	flicker_timer += delta
	
	# Erratic flickering light
	var base_flicker = sin(flicker_timer * FLICKER_SPEED) * 0.3
	var random_flicker = randf_range(-0.1, 0.1)
	light_emitter.energy = clamp(flicker_intensity + base_flicker + random_flicker, 0.1, 1.0)
	
	# Occasionally trigger a big flicker burst
	if randf() < 0.002:
		light_emitter.energy = 1.0
