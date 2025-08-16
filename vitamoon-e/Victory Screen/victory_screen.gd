extends Control

#Gain access to the mouse_lock and gamemanager classes
const mouseLock = preload("res://addons/srcoder_fps_controller/assets/scripts/mouse_lock.gd")
const gameManager = preload("res://GameManager.gd")

#Re-enable cursor so the user can properly interact with the menu
func _ready():
	mouseLock.new().set_paused(true)
	
	var numKilled = Global.kill_count
	
	$MarginContainer/HBoxContainer/VBoxContainer/VictoryText.text = "The enemies have been extinguished. 
	
	You killed %d enemies. Now the citizens of the moon will sleep easy, knowing the Special Moon Force 
	has taken care of the Sunny-E criminal scum. Would you like to once again take up arms against such 
	dastardly evil? Or has your thirst for justice been righteously served?" % [numKilled]

func Try_Again_Button_Pressed():
	Global._reset_kill_count()
	get_tree().change_scene_to_file("res://3dStart.tscn")

func Exit_Button_Pressed():
	get_tree().quit()
