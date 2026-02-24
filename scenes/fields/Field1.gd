extends Node2D

func _ready() -> void:
	var wispkin = load("res://scripts/resources/spirits/wispkin.tres")
	var grain = load("res://scripts/resources/crops/grain.tres")
	print("Spirit loaded: ", wispkin.spirit_name)
	print("Crop loaded: ", grain.crop_name)
	print("Wispkin traits: ", wispkin.traits)
