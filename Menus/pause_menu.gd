extends Control

@onready var game = $".."

func _on_resume_pressed() -> void:
	game.pauseMenu()
