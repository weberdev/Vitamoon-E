extends Node2D
#Brief: Audio Controller put in so we can play sounds wherever we need it rather than 
#attaching it to existing nodes.
#TODO: Put looping music here to centralize all the audio in one place. 


func Play_Laser_Gunshot():
	$"Shoot SFX".play()

#This will play when the player takes damage at full health or three quarter health
func Play_First_Oof_SFX():
	$"Player Hurt SFX #1".play()

#This will play when the player takes damage at less than 
func Play_Second_Oof_SFX():
	$"Player Hurt SFX #2".play()
	
func Play_Player_Died_SFX():
	$"Player Dead SFX".play()

func Play_Monster_Dying_SFX():
	$"Monster Dead SFX".play()
	
func Play_Monster_Hurt_SFX():
	$"Monster Hurt SFX".play()
