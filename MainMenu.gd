extends VBoxContainer

@onready var playButton = $Play
@onready var settingsButton = $Settings
@onready var quitButton = $Quit

# Called when the node enters the scene tree for the first time.
func _ready():
	playButton.pressed.connect(_on_play_button_pressed)
	settingsButton.pressed.connect(_on_settings_button_pressed)
	quitButton.pressed.connect(_on_quit_button_pressed)
	if Debug.load_game_on_start:
		get_tree().change_scene_to_file.call_deferred("res://Levels/Test/test_environ.tscn")
		# call deferred because scene change should be done when ready functions are complete
		# the scene tree is still being constructed during _ready calls, so it is unsafe otherwise
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/Test/test_environ.tscn")

func _on_settings_button_pressed() -> void:
	# to be implemented
	pass

func _on_quit_button_pressed() -> void:
	get_tree().quit()
