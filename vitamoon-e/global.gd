extends Node

#Desc: Keeps track of kill count and any other settings we may want to 
#store globally for any script file to use

var kill_count = 0

func _update_kill_count():
	kill_count += 1

#If player retry the game, the counter needs to be reset
func _reset_kill_count():
	kill_count = 0
