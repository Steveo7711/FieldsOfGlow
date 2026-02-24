extends Node

enum GameState { PLAYING, PAUSED, RETURNING }

var current_state: GameState = GameState.PLAYING
var current_field: String = "Field1"

func set_state(new_state: GameState) -> void:
	current_state = new_state
	EventBus.game_state_changed.emit(current_state)
