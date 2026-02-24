extends CanvasModulate

# Colors for each time of day
const DAWN_COLOR = Color(1.0, 0.85, 0.7)       # warm orange sunrise
const DAY_COLOR = Color(1.0, 1.0, 1.0)          # bright white midday
const DUSK_COLOR = Color(0.9, 0.7, 0.5)         # golden hour
const NIGHT_COLOR = Color(0.15, 0.15, 0.35)     # deep blue night

func _ready() -> void:
	EventBus.hour_changed.connect(_on_hour_changed)
	color = DAY_COLOR

func _on_hour_changed(hour: int) -> void:
	var target_color = _get_color_for_hour(hour)
	# Smoothly tween to new color
	var tween = create_tween()
	tween.tween_property(self, "color", target_color, 2.0)

func _get_color_for_hour(hour: int) -> Color:
	match hour:
		5, 6, 7:
			return DAWN_COLOR
		8, 9, 10, 11, 12, 13, 14, 15, 16:
			return DAY_COLOR
		17, 18, 19:
			return DUSK_COLOR
		20, 21, 22, 23, 0, 1, 2, 3, 4:
			return NIGHT_COLOR
		_:
			return DAY_COLOR
