extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

signal pick_up_items


@onready var interact_area:Area3D = $Area3D
var player_target : Target

func _ready():
	player_target = Target.new()
	player_target.name = "Player Target"
	player_target.SetNextTarget(player_target)
	add_child(player_target)
	
	interact_area.body_entered.connect(on_body_enter)
	interact_area.body_exited.connect(on_body_exit)
	
	if !OS.is_debug_build():
		var interact_area_mesh = $Area3D/MeshInstance3D
		interact_area_mesh.queue_free()

func _physics_process(delta):
	# Add the gravity.
	
	if Debug.quit_on_escape:
		if Input.is_action_just_pressed("Escape"):
			get_tree().quit()
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("Interact"):
		pick_up_items.emit()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBackward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
func on_body_enter(body:Node3D) -> void:
	if body is Item:
		body.show_ui_value = true
		body.item_changed.emit(body.id, body.show_ui, body.show_ui_value)

func on_body_exit(body:Node3D) -> void:
	if body is Item:
		body.show_ui_value = false
		body.item_changed.emit(body.id, body.show_ui, body.show_ui_value)
