extends CharacterBody3D

@onready var gun_controller = $GunController

var speed = 8
#Executed every frames:
func _process(delta):
	
	
	
	#Movement
	velocity = Vector3()
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.z -= 1
	if Input.is_action_pressed("move_down"):
		velocity.z += 1
	
	velocity = velocity.normalized()*speed
	move_and_slide()
	
	#Shooting
	if Input.is_action_pressed("shoot"):
		print("shooting")
		gun_controller.shoot()
