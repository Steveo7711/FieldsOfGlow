extends CanvasLayer

@onready var title_label: Label = $Control/Panel/VBoxContainer/TitleLabel
@onready var time_away_label: Label = $Control/Panel/VBoxContainer/TimeAwayLabel
@onready var crops_grown_label: Label = $Control/Panel/VBoxContainer/CropsGrownLabel
@onready var harvests_ready_label: Label = $Control/Panel/VBoxContainer/HarvestsReadyLabel
@onready var mutations_label: Label = $Control/Panel/VBoxContainer/MutationsLabel
@onready var day_label: Label = $Control/Panel/VBoxContainer/DayLabel
@onready var continue_button: Button = $Control/Panel/ContinueButton

func _ready() -> void:
	visible = false
	continue_button.pressed.connect(_on_continue_pressed)
	EventBus.afk_return_ready.connect(_on_afk_return)

func _on_afk_return(summary: Dictionary) -> void:
	title_label.text = "Welcome Back!"
	time_away_label.text = "Away for: %s" % _format_time(summary.get("seconds_away", 0))
	crops_grown_label.text = "Crops grew: %d times" % summary.get("crops_grown", 0)
	harvests_ready_label.text = "Ready to harvest: %d" % summary.get("harvestable_count", 0)
	mutations_label.text = "Mutations: %d" % summary.get("mutations", 0)
	day_label.text = "Now Day %d" % TimeManager.current_day
	visible = true
	TimeManager.pause()

func _on_continue_pressed() -> void:
	visible = false
	TimeManager.resume()

func _format_time(seconds: int) -> String:
	if seconds < 60:
		return "%d seconds" % seconds
	elif seconds < 3600:
		return "%d minutes" % (seconds / 60)
	else:
		return "%d hours" % (seconds / 3600)
