extends CharacterBody3D
class_name Player
signal dash_started

var score = 0



@onready var animated_sprite_3D :AnimatedSprite3D = $AnimatedSprite3D
@export var move_speed : float = 8.0  # movement speed
@export var jump_impulse : float = 12.0  # jump impulsion
@export var gravity : float = 20.0  # Gravité
#@onready var sound_barrier = $"Sonic Boom/Schockwave"

#Dash
@onready var dash_sound = $AudioStreamPlayer
@export var dash_speed : float = 30.0  # Vitesse du dash
@export var dash_duration : float = 0.1  # Durée du dash
@export var dash_cooldown : float = 1.0  # Temps de recharge entre chaque dash

enum State { idle, run_h, run_v, jump, dash } # run_v: vertical, run_h: horizontal

var current_state : State = State.idle
var dash_time_left : float = 0.0  # Temps restant pour le dash
var dash_cooldown_left : float = 0.0  # Temps restant avant de pouvoir refaire un dash



signal pick_up_items
signal start_dialog(actor_id:int)
signal continue_dialog
var is_in_dialog = false
var inventory:Dictionary = {Item.TYPE.CASH:false, Item.TYPE.KOMPROMAT:false, Item.TYPE.TICKET:false}

const NULL_ID = -1
var actor_id = NULL_ID # -1 means there is no actor to speak to

@onready var interact_area:Area3D = $Area3D
var player_target : Target

func _ready():
	velocity = Vector3(0,velocity.y, 0)
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	player_target = Target.new()
	player_target.name = "Player Target"
	player_target.SetNextTarget(player_target)
	add_child(player_target)
	
	interact_area.body_entered.connect(on_body_enter)
	interact_area.body_exited.connect(on_body_exit)
	
	animated_sprite_3D.play("run_down")
	animated_sprite_3D.pause()
	animated_sprite_3D.stop()
	
func _physics_process(delta):
	if Engine.time_scale == 1:
		game_behavior(delta)

func game_behavior(delta: float):
	velocity = Vector3(0,velocity.y,0)
	
	# Gravity
	if not is_on_floor():  #if the character is in the air
		velocity.y -= gravity * delta

		

	# Horizontal movement
	var direction = Vector3.ZERO
	
	direction.x = Input.get_axis("MoveLeft","MoveRight")
	direction.z = Input.get_axis("MoveForward","MoveBackward")

	# speed normalization
	direction = direction.normalized()
	
	if current_state == State.dash:
		velocity = direction * dash_speed
		dash_time_left -= delta
		if dash_time_left <= 0:
			current_state = State.idle
		else:
			pass
	else:
		# Horizontal speed
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
	
	# Jump
	if is_on_floor() and Input.is_action_just_pressed("Jump"):
		velocity.y += jump_impulse
		current_state = State.jump
		animated_sprite_3D.play("jump")
		print("Jump")
		
	# Dash
	if Input.is_action_just_pressed("Dash") and dash_cooldown_left <= 0 and current_state != State.dash:
		dash_sound.play()
		#sound_barrier.emit_particle()
		start_dash(direction)
	
	if dash_cooldown_left > 0:
		dash_cooldown_left -= delta
		
	if current_state != State.dash:
		update_animation()
		
	if Input.is_action_just_pressed("Interact"):
		pick_up_items.emit()
		start_dialog.emit(actor_id)

	#Movement
	move_and_slide()

func start_dash(direction: Vector3):
	# start dash in the hold direction
	current_state = State.dash
	emit_signal("dash_started")
	dash_time_left = dash_duration
	dash_cooldown_left = dash_cooldown  # Lancer le cooldown pour le prochain dash
	#Dash speed
	velocity = direction * dash_speed

func update_animation():
	# Change animation base on the current_state
	var frame : float = animated_sprite_3D.get_frame_progress()
	if velocity.z != 0:
		current_state = State.run_v
		if velocity.z > 0:
			animated_sprite_3D.play("run_down")
		else :
			animated_sprite_3D.play("run_up")
	elif velocity.x != 0:
		current_state = State.run_h
		if velocity.x > 0:
			animated_sprite_3D.play("run_right")
		else:
			animated_sprite_3D.play("run_left")
	elif is_on_floor():
		current_state = State.idle
		animated_sprite_3D.pause()
		animated_sprite_3D.stop()
		 # Remplace par ton animation "idle"
	else:
		print("Frame: %d" % frame)
		animated_sprite_3D.play(animated_sprite_3D.animation)
		animated_sprite_3D.set_frame_progress(frame)

func dialog_behavior():
	if Input.is_action_just_pressed("Interact"):
		continue_dialog.emit()

func on_body_enter(body:Node3D) -> void:
	if body is Actor:
		var actor :Actor = body
		if actor.interact_text != null && !actor.has_item:
			actor.interact_text.visible = true
			actor_id = actor.id
	if body is Item:
		var item : Item = body
		item.show_ui_value = true
		item.item_changed.emit(item.id, item.show_ui, item.show_ui_value)

func on_body_exit(body:Node3D) -> void:
	if body is Actor:
		var actor : Actor = body
		if actor.interact_text != null:
			actor.interact_text.visible = false
		actor_id = NULL_ID
	if body is Item:
		var item : Item = body
		item.show_ui_value = false
		item.item_changed.emit(item.id, item.show_ui, item.show_ui_value)
