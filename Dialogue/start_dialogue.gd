extends Control

var dialogue = [
	"XX, XX, 2103\nWelcome operative.\nYour objective is to secure full control of the saloon and the surrounding terrain.",
	
	"There are three inhabitants that interfere with your objective.\nEveryone has a weakness.\nGather intelligence to force the inhabitants into surrender.",
	
	"Although you may engage in combat, it may cause collalteral damage.\nWhichever method you choose, ensure success by any means necessary.\nGood luck.",
]

var current_line = 0

@onready var start_text = $StartText
@onready var next_button = $NextButton
var dialogue_finished = false

func _ready():
	#Freeze game except UI
	Engine.time_scale = 0
	update_dialogue()


func update_dialogue():
	if current_line < dialogue.size():
		start_text.text = dialogue[current_line]
	else:
		dialogue_finished = true
		#Unfreezes game
		Engine.time_scale = 1
		#Hides entire start dialogue
		$".".hide()


func _on_continue_button_pressed() -> void:
	current_line += 1
	update_dialogue()
