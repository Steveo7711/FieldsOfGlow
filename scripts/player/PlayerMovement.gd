extends CharacterBody2D

const SPEED = 80.0

@onready var interact_area: Area2D = $InteractArea

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if direction != Vector2.ZERO:
		velocity = direction.normalized() * SPEED
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		_try_interact()

func _try_interact() -> void:
	var overlapping = interact_area.get_overlapping_areas()
	for area in overlapping:
		if area.is_in_group("crops"):
			var crop = area as CropTile
			if crop.is_harvestable:
				crop.harvest()
				return
