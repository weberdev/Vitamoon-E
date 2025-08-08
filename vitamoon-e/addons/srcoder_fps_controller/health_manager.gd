extends Node3D
signal health_changed(new_health:int)

@export var max_health := 4
var health := max_health

func _ready():
	emit_signal("health_changed", health)  # initialize HUD on load

func take_damage(dmg:int) -> void:
	health = clamp(health - dmg, 0, max_health)
	emit_signal("health_changed", health)
