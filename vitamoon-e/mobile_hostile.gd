extends CharacterBody3D
@onready var nav_agent = $NavigationAgent3D
@export var speed: float = 10.0
@export var atk_cooldown := 0.6
@export var atk_dmg := 1
@export var _attack_pose_time := 0.2
var player
var _next_atk_tim := 0.0
var _is_atk := false
var _player_hit_counter := 0
var is_alive := true
@export var health := 3
var static_sprite    = load("res://assets_2d/Neutral Pose Evil Sunny-E Guy.png")
var attacking_sprite = load("res://assets_2d/Going to Strike Pose Evil Sunn-E Guy.png")
var dead_sprite      = load("res://assets_2d/Dead Pose Evil Sunny-E Guy.png")
var idle = true
signal dead

func _ready():
	$Sprite3D.texture = static_sprite
	player = get_node_or_null("/root/Node3D/Player")
	if player:
		print("player found!")
	else:
		print("No player found")

func _process(_delta):
	## Every 5 frames ray-cast towards the player
	## If the ray collides with the player then activate
	if idle and Engine.get_process_frames() % 5 == 0:
		var ray_origin = global_transform.origin
		var ray_end = player.global_transform.origin
		var new_intersection = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
		var intersection = get_world_3d().direct_space_state.intersect_ray(new_intersection)
		if intersection.collider.is_in_group("Player"):
			idle = false
			
func Hit(damage):
	if not is_alive:
		return
	health -= damage
	print("Remaning HP: " + str(health))
	if health <= 0:
		is_alive = false                 
		$Sprite3D.scale = Vector3(0.4,0.4,0.4)
		$Sprite3D.texture = dead_sprite
		$Sprite3D.position -= Vector3(0,1,0)
		$CollisionShape3D.disabled = true
		AudioController.Play_Monster_Dying_SFX()
		emit_signal("dead")                     
		set_physics_process(false)
	else:
		AudioController.Play_Monster_Hurt_SFX()

func _physics_process(delta):
	if not is_alive or player == null or health <= 0 or idle:
		return
		
	var to_player = player.global_transform.origin - global_transform.origin
	var distance = to_player.length()
	if distance > 1.5:
		var current_location = global_transform.origin
		var next_location = nav_agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * speed
		velocity = velocity.move_toward(new_velocity, .25)
		move_and_slide()
		if not _is_atk:
			$Sprite3D.texture = static_sprite
	else:
		velocity = Vector3.ZERO
		move_and_slide()
		attack_player()

func update_target_location(target_location):
	nav_agent.set_target_position(target_location)

func attack_player():
	if not is_alive or player == null:
		return

	var curTime := Time.get_ticks_msec() / 1000.0
	if curTime < _next_atk_tim:
		return # on cooldown
	_next_atk_tim = curTime + atk_cooldown

	_is_atk = true                   
	$Sprite3D.texture = attacking_sprite

	# Safely hit the player (they might be gone after game over)
	if is_instance_valid(player) and player.has_method("take_damage"):
		player.take_damage(atk_dmg)

	_player_hit_counter += 1
	if _player_hit_counter < 4:
		await get_tree().create_timer(_attack_pose_time).timeout
		if is_alive and not is_queued_for_deletion():
			_is_atk = false
			$Sprite3D.texture = static_sprite
