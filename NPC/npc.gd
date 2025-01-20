extends CharacterBody3D

var movement_speed: float = 2.0
var movement_target_position: Vector3
var last_target: Target = null
@export var target: Target
var is_target_reached := false
var player_target :Target

@export var follow_player = false

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

func _ready():
	# These values need to be adjusted for the actor's speed and the navigation layout.
	player_target = $"../../Player".player_target # look into signals for switching target to and from player
	print(Target.GetName(player_target))
	movement_target_position = Target.GetPosition(target)
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5
	# Make sure to not await during _ready.
	actor_setup.call_deferred()

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(movement_target_position)

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func _physics_process(delta):
	if Input.is_action_just_pressed("Interact"):
		follow_player = !follow_player
	if (follow_player and target != player_target) or (!follow_player and target == player_target):
		print()
		print(Target.GetName(last_target))
		print(Target.GetName(target))
		if target == player_target:
			target = last_target
			last_target = player_target
		else:
			last_target = target
			target = player_target
		movement_target_position = Target.GetPosition(target)
		actor_setup()

		
	
	if (movement_target_position - position).length() < navigation_agent.target_desired_distance:
		print(Target.GetName(target))
		print(Target.GetName(last_target))
		if target != player_target:
			last_target = target
			target = Target.GetNextTarget(target)
		else:
			target = last_target
			last_target = player_target
		movement_target_position = Target.GetPosition(target)
		actor_setup()

	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = movement_target_position

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()
