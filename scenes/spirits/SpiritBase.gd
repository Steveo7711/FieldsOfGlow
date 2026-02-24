class_name SpiritBase
extends CharacterBody2D

@export var spirit_data: SpiritData

@onready var light_emitter: PointLight2D = $LightEmitter
@onready var light_area: Area2D = $LightArea
@onready var interaction_area: Area2D = $InteractionArea
@onready var spirit_visual: AnimatedSprite2D = $SpiritVisual
@onready var glow_particles: GPUParticles2D = $GlowParticles
@onready var state_machine: SpiritStateMachine = $SpiritStateMachine

func _ready() -> void:
	add_to_group("spirits")
	if spirit_data:
		_apply_spirit_data()
	EventBus.spirit_spawned.emit(self)
	
	# Connect interaction area to detect player
	interaction_area.body_entered.connect(_on_body_entered_interaction)
	interaction_area.body_exited.connect(_on_body_exited_interaction)

func _apply_spirit_data() -> void:
	light_emitter.color = spirit_data.light_color
	light_emitter.energy = spirit_data.light_intensity
	light_emitter.texture_scale = spirit_data.light_radius / 40.0
	
	var light_shape = light_area.get_node("CollisionShape2D")
	var circle = CircleShape2D.new()
	circle.radius = spirit_data.light_radius
	light_shape.shape = circle
	
	var material = glow_particles.process_material as ParticleProcessMaterial
	if material:
		material.color = spirit_data.light_color

func get_spirit_id() -> String:
	return spirit_data.spirit_id if spirit_data else "unknown"

func _on_body_entered_interaction(body: Node2D) -> void:
	if body.is_in_group("player"):
		state_machine.transition_to("reacting")

func _on_body_exited_interaction(body: Node2D) -> void:
	if body.is_in_group("player"):
		state_machine.transition_to("wandering")
