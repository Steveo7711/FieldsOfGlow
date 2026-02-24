class_name WanderingState
extends State

const FIELD_MIN = Vector2(20, 20)
const FIELD_MAX = Vector2(1260, 940)

const MIN_WAIT = 1.5
const MAX_WAIT = 4.0

var target_position: Vector2 = Vector2.ZERO
var is_waiting: bool = false
var wait_timer: float = 0.0
var wait_duration: float = 0.0
var _move_speed: float = 40.0

func enter() -> void:
	# Restless spirits move faster
	if spirit.spirit_data:
		if spirit.spirit_data.temperament == SpiritData.TemperamentType.RESTLESS:
			_move_speed = 70.0
		else:
			_move_speed = 40.0
	_pick_new_target()

func update(delta: float) -> void:
	if is_waiting:
		wait_timer += delta
		if wait_timer >= wait_duration:
			is_waiting = false
			_pick_new_target()

func physics_update(delta: float) -> void:
	if is_waiting:
		spirit.velocity = Vector2.ZERO
		spirit.move_and_slide()
		return
	
	var direction = (target_position - spirit.global_position)
	
	if direction.length() < 5.0:
		is_waiting = true
		wait_timer = 0.0
		wait_duration = randf_range(MIN_WAIT, MAX_WAIT)
		spirit.velocity = Vector2.ZERO
	else:
		spirit.velocity = direction.normalized() * _move_speed
	
	spirit.move_and_slide()

func _pick_new_target() -> void:
	target_position = Vector2(
		randf_range(FIELD_MIN.x, FIELD_MAX.x),
		randf_range(FIELD_MIN.y, FIELD_MAX.y)
	)
