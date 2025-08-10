extends CharacterBody3D

func take_damage(damage: int):
	health_manager.take_damage(damage)

@onready var moonHealth: TextureRect = get_node("CanvasLayer/HPTracker")

## The movement speed in m/s. Default is 5.
@export_range(1.0,30.0) var speed : float = 5.0
## The Jump Velocity in m/s- default to 6.0
@export_range(2.0,10.0) var jump_velocity : float = 6.0

## Mouse sensitivity for looking around. Default is 3.0
@export_range(1.0,5.0) var mouse_sensitivity = 3.0
var mouse_motion : Vector2 = Vector2.ZERO
var pitch = 0

## The amount of acceleration on the ground- less feels floaty, more is snappy-[br]Default is 4
@export_range(1.0,10.0) var ground_acceleration := 4.0
## the amount of acceleration when in the air. less feels more floaty more is more snappy.[br]Default is 0.5
@export_range(0.0,5.0) var air_acceleration := 0.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
@export_range(5.0,25.0) var gravity : float = 15.0

# the camera pivot for head pitch movement
@onready var camera_pivot : Node3D = $CameraPivot

@onready var health_manager  = $CameraPivot/Camera3D/Health_Manager
@onready var hud = $CanvasLayer    
var ICONS := {
	4: preload("res://assets_2d/Player Health Asset - Full.png"),
	3: preload("res://assets_2d/Player Health Asset - Three Quarters.png"),
	2: preload("res://assets_2d/Player Health Asset - Half.png"),
	1: preload("res://assets_2d/Player Health Asset - One Quarter.png"),
	0: preload("res://assets_2d/Player Health Asset - Zero.png"),
}

func _ready():
	health_manager.health_changed.connect(_on_health_changed)
	_on_health_changed(health_manager.health)

func _on_health_changed(h:int) -> void:
	h = clamp(h, 0, 4)
	moonHealth.texture = ICONS[h]
	#Checking if player lost health from full or three quarters
	if h == 3 || h == 2:
		AudioController.Play_First_Oof_SFX()
	#Checking if player lost health from half
	elif h == 1:
		AudioController.Play_Second_Oof_SFX()
	#While we don't yet have an end screen, this is commented out so you don't
	#have to repeatedly hear the player die when taking damage after he died.
	#Uncomment this out once we can properly end the game.
	#Check if player is already dead.
	elif h == 0:
		AudioController.Play_Player_Died_SFX()
		get_tree().change_scene_to_file("res://Game Over/game_over.tscn")	

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	var target_velocity := Vector3.ZERO
	if direction:
		target_velocity = direction
	#now apply velocity with lerp based on whether on ground or in air
	if is_on_floor():
		velocity.x = move_toward(velocity.x , target_velocity.x * speed , speed * ground_acceleration * delta)
		velocity.z = move_toward(velocity.z, target_velocity.z * speed, speed * ground_acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x , target_velocity.x * speed , speed * air_acceleration * delta)
		velocity.z = move_toward(velocity.z, target_velocity.z * speed, speed * air_acceleration * delta)
	#now actually move based on velocity
	move_and_slide()
	
	#rotate the player and camera pivot based on mouse movement
	rotate_y(-mouse_motion.x * mouse_sensitivity / 1000)
	pitch -= mouse_motion.y * mouse_sensitivity / 1000
	pitch = clampf(pitch,-1.35,1.35)
	camera_pivot.rotation.x = pitch
	#reset it
	mouse_motion = Vector2.ZERO
	

#handle and store mouse motion
func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		mouse_motion = event.relative
		
