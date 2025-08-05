extends StaticBody3D

var health = 3

func Hit(damage):
	health -= damage
	print("Remaning HP: " + str(health))
	if health <= 0:
		queue_free()
