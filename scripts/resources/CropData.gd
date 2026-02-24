class_name CropData
extends Resource

enum CropCategory { GRAIN, GLOWFLOWER, FRUITVINE, RARE }

@export var crop_name: String = ""
@export var crop_id: String = ""
@export var growth_stages: int = 4
@export var base_growth_ticks: int = 8
@export var preferred_light_color: Color = Color.WHITE
@export var mutation_chance: float = 0.05
@export var yield_resource: String = ""
@export var stage_sprites: Array[Texture2D] = []
@export var category: CropCategory = CropCategory.GRAIN
