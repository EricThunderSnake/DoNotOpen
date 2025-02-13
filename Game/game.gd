extends WorldEnvironment


@onready var pause_menu = $"Pause Menu"
@onready var start_dialogue = $"Start Dialogue"

var paused = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Escape") && !start_dialogue.visible:
		pauseMenu()


func pauseMenu():
	if not paused or pause_menu == null:
		pause_menu.show()
		Engine.time_scale = 0
	else:
		pause_menu.hide()
		Engine.time_scale = 1
		
	paused = !paused
