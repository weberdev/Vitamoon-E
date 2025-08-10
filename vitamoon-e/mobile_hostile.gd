extends CharacterBody3D
@export var speed: float = 2.0
var player
@export var atk_cooldown := 0.6
@export var atk_dmg := 1
var _next_atk_tim := 0.0
@export var _attack_pose_time := 0.2
var _is_atk := false
#Added player hit counter so we stop attacking if player is dead
var _player_hit_counter = 0

var health = 3
var static_sprite = load("res://assets_2d/Neutral Pose Evil Sunny-E Guy.png")
var attacking_sprite = load("res://assets_2d/Going to Strike Pose Evil Sunn-E Guy.png")
var dead_sprite = load("res://assets_2d/Dead Pose Evil Sunny-E Guy.png")

func _ready():
	$Sprite3D.texture = static_sprite
	player = get_tree().get_root().get_node("Node3D/Player")
	if player:
		print("player found!")
	else:
		print("No player found")


func Hit(damage):
	health -= damage
	print("Remaning HP: " + str(health))
	if health <= 0:
		$Sprite3D.scale = Vector3(0.4,0.4,0.4)
		$Sprite3D.texture = dead_sprite
		$Sprite3D.position = $Sprite3D.position - Vector3(0,1,0)
		$CollisionShape3D.disabled = true
		AudioController.Play_Monster_Dying_SFX()
	else:
		AudioController.Play_Monster_Hurt_SFX()
		
func _physics_process(delta):
	if not player or health <= 0:
		return
		
	var to_player = player.global_transform.origin -global_transform.origin
	var distance = to_player.length()
	if distance > 1.5:
		var direction = to_player.normalized()
		velocity = direction *speed
		move_and_slide()
		$Sprite3D.texture = static_sprite
	else:
		velocity = Vector3.ZERO
		move_and_slide()
		attack_player()
		
func attack_player():
	#print("OOGA BOOGA")N
	var curTime := Time.get_ticks_msec()/1000.0
	if curTime < _next_atk_tim:
		return #on CD
	_next_atk_tim= curTime+atk_cooldown
	$Sprite3D.texture= attacking_sprite
	player.take_damage(atk_dmg)
	#Ensure the enemy stops attacking if the player has died. This conditional is
	#done as otherwise, the enemy keeps attacking and the get_tree() throws an exception
	#as we've moved on to the game over screen, yet it is still trying to grab the main game
	#instance. A better fix may be to change the timer to not use the tree.
	_player_hit_counter += 1
	if (_player_hit_counter < 4):
		await get_tree().create_timer(_attack_pose_time).timeout
		if health > 0 and _is_atk: # still alive & still in attack state
			$Sprite3D.texture = static_sprite
			_is_atk = false
