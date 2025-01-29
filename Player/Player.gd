extends CharacterBody3D

class_name Player

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var inventory:Dictionary = {Item.TYPE.CASH:false, Item.TYPE.KOMPROMAT:false, Item.TYPE.TICKET:false}

signal pick_up_items
signal start_dialog(actor_id:int)
signal continue_dialog
var is_in_dialog = false

const NULL_ID = -1
var actor_id = NULL_ID # -1 means there is no actor to speak to

@onready var interact_area:Area3D = $Area3D
var player_target : Target

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	player_target = Target.new()
	player_target.name = "Player Target"
	player_target.SetNextTarget(player_target)
	add_child(player_target)
	
	interact_area.body_entered.connect(on_body_enter)
	interact_area.body_exited.connect(on_body_exit)

func _physics_process(delta):
	if !get_tree().paused:
		game_behavior(delta)
	

func dialog_behavior():
	if Input.is_action_just_pressed("Interact"):
		continue_dialog.emit()
	

func game_behavior(delta:float) -> void:
	velocity = Vector3(0, velocity.y, 0)
	
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
		start_dialog.emit(actor_id)
		
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
	if body is not Player:
		if body.interact_text != null:
			body.interact_text.visible = true
	if body is Actor:
		var actor :Actor = body
		actor_id = actor.id
	if body is Item:
		var item : Item = body
		item.show_ui_value = true
		item.item_changed.emit(item.id, item.show_ui, item.show_ui_value)

func on_body_exit(body:Node3D) -> void:
	if body is not Player:
		if body.interact_text != null:
			body.interact_text.visible = false
	if body is Actor:
		actor_id = NULL_ID
	if body is Item:
		var item : Item = body
		item.show_ui_value = false
		item.item_changed.emit(item.id, item.show_ui, item.show_ui_value)
