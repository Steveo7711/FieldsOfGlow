class_name ReactingState
extends State

const FLEE_SPEED = 80.0
const CURIOUS_SPEED = 30.0

var player_position: Vector2 = Vector2.ZERO

func enter() -> void:
	# Find player position
	var player = spirit.get_tree().get_first_node_in_group("player")
	if player:
		player_position = player.global_position

func update(delta: float) -> void:
	var player = spirit.get_tree().get_first_node_in_group("player")
	if player:
		player_position = player.global_position
	else:
		spirit.state_machine.transition_to("wandering")

func physics_update(delta: float) -> void:
	if not spirit.spirit_data:
		return
	
	var direction = (player_position - spirit.global_position).normalized()
	
	match spirit.spirit_data.temperament:
		SpiritData.TemperamentType.SHY:
			# Flee away from player
			spirit.velocity = -direction * FLEE_SPEED
		SpiritData.TemperamentType.CURIOUS:
			# Move toward player slowly
			spirit.velocity = direction * CURIOUS_SPEED
		_:
			# Neutral - just stop
			spirit.velocity = Vector2.ZERO
	
	spirit.move_and_slide()
