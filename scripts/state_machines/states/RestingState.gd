class_name RestingState
extends State

const REST_DURATION_MIN = 8.0
const REST_DURATION_MAX = 20.0

var rest_timer: float = 0.0
var rest_duration: float = 0.0

func enter() -> void:
	rest_timer = 0.0
	rest_duration = randf_range(REST_DURATION_MIN, REST_DURATION_MAX)
	spirit.velocity = Vector2.ZERO

func update(delta: float) -> void:
	rest_timer += delta
	if rest_timer >= rest_duration:
		spirit.state_machine.transition_to("wandering")

func physics_update(delta: float) -> void:
	spirit.velocity = Vector2.ZERO
	spirit.move_and_slide()
