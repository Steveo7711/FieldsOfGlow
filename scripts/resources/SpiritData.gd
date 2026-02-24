extends Resource

class_name SpiritData

enum MovementType { WANDERER, HOVERER, DRIFTER }
enum TemperamentType { CALM, CURIOUS, SHY, RESTLESS }

@export var spirit_name: String = ""
@export var spirit_id: String = ""
@export var light_intensity: float = 0.5
@export var light_color: Color = Color.WHITE
@export var light_radius: float = 80.0
@export var movement_pattern: MovementType = MovementType.WANDERER
@export var temperament: TemperamentType = TemperamentType.CALM
@export var traits: Array[String] = []
@export var base_scene: PackedScene = null
@export var sprite_frames: SpriteFrames = null
