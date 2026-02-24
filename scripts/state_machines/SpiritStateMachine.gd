class_name SpiritStateMachine
extends Node

@export var initial_state: State

var current_state: State
var states: Dictionary = {}

func _ready() -> void:
	# Register all child states
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.spirit = get_parent()
	
	# Enter initial state
	if initial_state:
		current_state = initial_state
		current_state.enter()

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func transition_to(state_name: String) -> void:
	if not states.has(state_name):
		print("State not found: ", state_name)
		return
	
	if current_state:
		current_state.exit()
	
	current_state = states[state_name]
	current_state.enter()
	EventBus.spirit_state_changed.emit(owner, state_name)
