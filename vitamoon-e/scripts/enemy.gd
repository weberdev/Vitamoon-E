extends StaticBody3D

var health = 3
var static_sprite = load("res://assets_2d/Neutral Pose Evil Sunny-E Guy.png")
var attacking_sprite = load("res://assets_2d/Attacking Pose Evil Sunny-E Guy.png")
var dead_sprite = load("res://assets_2d/Dead Pose Evil Sunny-E Guy.png")

func ready():
	$Sprite3D.texture = static_sprite

func Hit(damage):
	health -= damage
	print("Remaning HP: " + str(health))
	if health <= 0:
		$Sprite3D.scale = Vector3(0.4,0.4,0.4)
		$Sprite3D.texture = dead_sprite
		$Sprite3D.position = $Sprite3D.position - Vector3(0,1,0)
		$CollisionShape3D.disabled = true
