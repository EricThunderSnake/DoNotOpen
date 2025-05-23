extends Control
@onready var audio_stream_player = $"../AudioStreamPlayer"

var dialogue = [
	"XX, XX, 2103\n\nWelcome operative.\n\nYour objective is to secure full control of the interior and exterior of the saloon.",
	
	"There are three inhabitants that interfere with your objective.\n\nEveryone has a weakness.\n\nGather intelligence to force the inhabitants into surrender.",
	
	"Good luck.",
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
