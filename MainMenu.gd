extends VBoxContainer

@onready var playButton = $Play
@onready var settingsButton = $Settings
@onready var quitButton = $Quit

@export var test_on_boot = false


# Called when the node enters the scene tree for the first time.
func _ready():
	playButton.pressed.connect(_on_play_button_pressed)
	settingsButton.pressed.connect(_on_settings_button_pressed)
	quitButton.pressed.connect(_on_quit_button_pressed)
	if test_on_boot:
		test_on_boot = false
		get_tree().change_scene_to_file("res://Levels/Test/pathfinding.tscn")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/Test/pathfinding.tscn")

func _on_settings_button_pressed() -> void:
	# to be implemented
	pass

func _on_quit_button_pressed() -> void:
	get_tree().quit()
