extends Node

enum GameState { PLAYING, PAUSED, RETURNING }

var current_state: GameState = GameState.PLAYING
var current_field: String = "field1"

func _ready() -> void:
	EventBus.game_state_changed.connect(_on_game_state_changed)

func set_state(new_state: GameState) -> void:
	current_state = new_state
	EventBus.game_state_changed.emit(current_state)

func _on_game_state_changed(state: GameState) -> void:
	match state:
		GameState.PAUSED:
			TimeManager.pause()
		GameState.PLAYING:
			TimeManager.resume()

func change_field(field_id: String) -> void:
	current_field = field_id
	DataManager.save_game()
	var field_path = "res://scenes/fields/%s.tscn" % field_id.capitalize()
	get_tree().change_scene_to_file(field_path)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		DataManager.save_game()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_APPLICATION_PAUSED:
		DataManager.save_game()
