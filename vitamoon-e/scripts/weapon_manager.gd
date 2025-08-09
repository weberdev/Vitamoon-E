extends Node3D

var can_shoot = true
var muzzle_flash_node

func _ready():
	## Get reference to muzzle flash texture
	muzzle_flash_node = get_node("../../../CanvasLayer/GunMuzzleFlash")
	
func _input(event):
	if event.is_action_pressed("shoot") and can_shoot:
		print("Schut")
		Shoot()
		AudioController.Play_Laser_Gunshot()
		
		## Show muzzle flash texture
		muzzle_flash_node.visible = true
		
		## Limit fire rate with timer
		var timer = get_tree().create_timer(0.4)
		timer.timeout.connect(timeout_function)

func Shoot():
	can_shoot = false
	var camera_collision = Get_Camera_Collision()
	
func Get_Camera_Collision():
	## Get the camera center
	var camera = get_viewport().get_camera_3d()
	var viewport = get_viewport().get_size()
	var ray_origin = camera.project_ray_origin(viewport/2)
	
	## Shoot out a ray out at a certain distance
	var ray_end = ray_origin + camera.project_ray_normal(viewport/2) * 2000
	var new_intersection = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	var intersection = get_world_3d().direct_space_state.intersect_ray(new_intersection)
	
	## If there is a collision with a collider then check it it's an enemy
	## If it is then pass the damage amount through the hit method
	if intersection:
		print(intersection.collider.name)
		if intersection.collider.is_in_group("Enemy") and intersection.collider.has_method("Hit"):
			intersection.collider.Hit(1)

func timeout_function():
	##On timer timeout reset shoot cooldown and turn off muzzle flash texture
	can_shoot = true
	muzzle_flash_node.visible = false
