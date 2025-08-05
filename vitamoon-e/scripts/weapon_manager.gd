extends Node3D

func _input(event):
	if event.is_action_pressed("shoot"):
		print("Schut")
		Shoot()

func Shoot():
	var camera_collision = Get_Camera_Collision()
	##Hit_Scan_Damage(camera_collision)
	
func Get_Camera_Collision():
	var camera = get_viewport().get_camera_3d()
	var viewport = get_viewport().get_size()
	var ray_origin = camera.project_ray_origin(viewport/2) ## Ray origin emits from screen center
	var ray_end = ray_origin + camera.project_ray_normal(viewport/2) * 2000 ##2000 is distance ray shoots out
	var new_intersection = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	var intersection = get_world_3d().direct_space_state.intersect_ray(new_intersection)

	if intersection:
		print(intersection.collider.name)
		Hit_Scan_Damage(intersection.collider)
		
func Hit_Scan_Damage(collision):
	if collision.is_in_group("Enemy") and collision.has_method("Hit"):
		collision.Hit(1)
