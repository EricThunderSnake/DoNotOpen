extends CharacterBody3D

class_name Actor

@onready var player = %Player

static var ASSIGN_ID := 0
var id :int

var movement_speed: float = 2.0
var movement_target_position: Vector3
var last_target: Target = null
@export var target: Target
var is_target_reached := false
var player_target :Target

var has_item = false
var has_correct_item = false

@export var dialog_json : String = "res://DialogWriteTest.json"
var dialog_scenes: Dictionary
var scene_id: int = 0
var dialog_id:int = 0
@export var nav_agent_active = false

@export var follow_player = false

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var interact_text = $InteractText

func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE
	
	id = ASSIGN_ID
	ASSIGN_ID += 1
	
	# These values need to be adjusted for the actor's speed and the navigation layout.
	player_target = player.player_target # look into signals for switching target to and from player
	movement_target_position = Target.GetPosition(target)
	nav_agent.path_desired_distance = 0.5
	nav_agent.target_desired_distance = 0.5
	
	dialog_scenes = read_dialog_file()
	
	# Make sure to not await during _ready.
	actor_setup.call_deferred()

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(movement_target_position)

func set_movement_target(movement_target: Vector3):
	nav_agent.set_target_position(movement_target)

func _physics_process(_delta):
	if nav_agent_active:
		if (follow_player and target != player_target) or (!follow_player and target == player_target):
			if target == player_target:
				target = last_target
				last_target = player_target
			else:
				last_target = target
				target = player_target
			movement_target_position = Target.GetPosition(target)
			actor_setup()

		if (movement_target_position - position).length() < nav_agent.target_desired_distance:
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

func test_write_json() -> void:
	for i in range(0,4):
		var test_dialog = {"Name":"Steve", "NextDialogID":1,"Speech":"Hello!"}
		var test2 = {"Name":"Steve",  "NextDialogID":-1, "Speech":"See ya!"}
		var scene:Dictionary
		scene[str(0)] = test_dialog
		scene[str(1)] = test2
		dialog_scenes[str(i)] = scene 
	var data_to_send = dialog_scenes
	var json_string = JSON.stringify(data_to_send)
	print(dialog_scenes)
	print(json_string)
	
	var file = FileAccess.open(dialog_json,FileAccess.WRITE)
	file.store_string(json_string)
	file.close()

func read_dialog_file() -> Dictionary:
	var file = FileAccess.open(dialog_json,FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.new()
	var error = json.parse(content)	
	if error == OK:
		var data_received = json.data
		if typeof(data_received) == TYPE_DICTIONARY:
			return data_received
		else:
			print("Unexpected data for Actor ID: d%" % id)
			return {}
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", content, " at line ", json.get_error_line())
		return {}
