extends Control

#Gain access to the mouse_lock class
#TODO: Probably wise to put this into a controller or something, like we have for the 
#Audio Controller
const mouseLock = preload("res://addons/srcoder_fps_controller/assets/scripts/mouse_lock.gd")

func _ready():
	mouseLock.new().set_paused(true)

func On_Reset_Pressed():
	Global._reset_kill_count()
	get_tree().change_scene_to_file("res://3dStart.tscn")

func On_Exit_Pressed():
	get_tree().quit()
