extends CharacterBody3D

@onready var gun_controller = $GunController

var speed = 8
#Executed every frames:
func _process(delta):
	
	

	#Movement
	velocity = Vector3()
	
	if Input.is_action_pressed("MoveRight"):
		velocity.x += 1
	if Input.is_action_pressed("MoveLeft"):
		velocity.x -= 1
	if Input.is_action_pressed("MoveForward"):
		velocity.z -= 1
	if Input.is_action_pressed("MoveBackward"):
		velocity.z += 1
	
	velocity = velocity.normalized()*speed
	move_and_slide()
	
	#Shooting
	if Input.is_action_pressed("Interact"):
		print("shooting")
		gun_controller.shoot()
