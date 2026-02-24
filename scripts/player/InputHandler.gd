extends Node

# Detects platform and routes input accordingly
# Keyboard/gamepad input is handled via Input.get_vector() in PlayerMovement
# Mobile touch input will be handled here when VirtualJoystick is implemented

func is_mobile() -> bool:
	return OS.get_name() == "Android" or OS.get_name() == "iOS"
