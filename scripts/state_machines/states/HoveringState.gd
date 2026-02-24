class_name HoveringState
extends State

const HOVER_DURATION_MIN = 5.0
const HOVER_DURATION_MAX = 15.0

var hover_timer: float = 0.0
var hover_duration: float = 0.0

func enter() -> void:
	hover_timer = 0.0
	hover_duration = randf_range(HOVER_DURATION_MIN, HOVER_DURATION_MAX)
	spirit.velocity = Vector2.ZERO

func update(delta: float) -> void:
	hover_timer += delta
	if hover_timer >= hover_duration:
		spirit.state_machine.transition_to("wandering")

func physics_update(delta: float) -> void:
	# Gentle bob in place
	spirit.velocity = Vector2(0, sin(hover_timer * 2.0) * 5.0)
	spirit.move_and_slide()
