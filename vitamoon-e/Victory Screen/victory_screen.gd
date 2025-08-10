extends Control

func Try_Again_Button_Pressed():
	get_tree().change_scene_to_file("res://3dStart.tscn")

func Exit_Button_Pressed():
	get_tree().quit()
