extends Control

func On_Play_Pressed():
	get_tree().change_scene_to_file("res://3dStart.tscn")

func On_Exit_Pressed():
	get_tree().quit()
