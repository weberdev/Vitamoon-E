extends CanvasLayer

@onready var heart = $HealthDisplay/TextureRect

var health_icons = {
	4: preload("res://assets_2d/Player Health Asset - Full.png"),
	3: preload("res://assets_2d/Player Health Asset - Three Quarters.png"),
	2: preload("res://assets_2d/Player Health Asset - Half.png"),
	1: preload("res://assets_2d/Player Health Asset - One Quarter.png"),
	0: preload("res://assets_2d/Player Health Asset - Zero.png")
}

func update_hearts(current_health):
	current_health = clamp(current_health, 0, 4)
	heart.texture = health_icons[current_health]
