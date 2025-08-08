extends Node3D
var hp_display

func _ready():
	## Get reference to muzzle flash texture
	hp_display = get_node("../../../CanvasLayer/HPTracker")
