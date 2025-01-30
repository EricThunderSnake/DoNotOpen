extends WorldEnvironment


@onready var pause_menu = $"Pause Menu"

var paused = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		pauseMenu()


func pauseMenu():
	if not paused:
		pause_menu.show()
		Engine.time_scale = 0
	else:
		pause_menu.hide()
		Engine.time_scale = 1
		
	paused = !paused
