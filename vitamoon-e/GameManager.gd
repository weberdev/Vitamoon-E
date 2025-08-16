extends Node
var remaining := 9
@onready var player = $Player

func _ready():
	remaining = get_tree().get_nodes_in_group("Enemy").size()
	for mobile_hostile in get_tree().get_nodes_in_group("Enemy"):
		mobile_hostile.dead.connect(_on_enemy_death)
		
func _on_enemy_death():
	Global._update_kill_count()
	remaining -= 1
	print ("Enemies remaining: ", remaining)
	if remaining <=0:
		_all_enemies_dead()
		
func _all_enemies_dead():
	print("VICTORY")
	get_tree().change_scene_to_file("res://Victory Screen/Victory Screen.tscn")
	
func _physics_process(delta):
	get_tree().call_group("Enemy", "update_target_location", player.global_transform.origin)
	
