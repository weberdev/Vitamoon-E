extends CharacterBody3D
@export var speed: float = 2.0
var player


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
		print("No player ofund>")


func Hit(damage):
	health -= damage
	print("Remaning HP: " + str(health))
	if health <= 0:
		$Sprite3D.scale = Vector3(0.4,0.4,0.4)
		$Sprite3D.texture = dead_sprite
		$Sprite3D.position = $Sprite3D.position - Vector3(0,1,0)
		$CollisionShape3D.disabled = true
		
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
		#$Sprite3d.texture= attacking_sprite
		attack_player()
		
func attack_player():
	print("OOGA BOOGA")
