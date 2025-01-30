extends CharacterBody3D
class_name Player
signal dash_started

@onready var animated_sprite_3D = $AnimatedSprite3D
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

func _ready():
	animated_sprite_3D.play("run_down")
	animated_sprite_3D.pause()
	animated_sprite_3D.stop()

func _physics_process(delta: float):
	# Gravity
	if not is_on_floor():  #if the character is in the air
		velocity.y -= gravity * delta
	else:
		velocity.y = 0   #Speed reinitialisation on ground (not necessary)
		

	# Horizontal movement
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_up"):
		direction.z -= 1
	if Input.is_action_pressed("move_down"):
		direction.z += 1

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
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y += jump_impulse
		current_state = State.jump
		animated_sprite_3D.play("jump")
		print("Jump")
		
	# Dash
	if Input.is_action_just_pressed("dash") and dash_cooldown_left <= 0 and current_state != State.dash:
		dash_sound.play()
		#sound_barrier.emit_particle()
		start_dash(direction)
	
	if dash_cooldown_left > 0:
		dash_cooldown_left -= delta
		
	if current_state != State.dash:
		update_animation()

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
	if !is_on_floor() and current_state == State.jump:
		animated_sprite_3D.pause()
	
	if velocity.z != 0 and is_on_floor():
		if velocity.z > 0:
			current_state = State.run_v
			animated_sprite_3D.play("run_down")
		else :
			animated_sprite_3D.play("run_up")
	elif velocity.x != 0 and is_on_floor():
		current_state = State.run_h
		if velocity.x > 0:
			animated_sprite_3D.play("run_right")
		else:
			animated_sprite_3D.play("run_left")
	else:
		current_state = State.idle
		animated_sprite_3D.pause()
		animated_sprite_3D.stop() # Remplace par ton animation "idle"
