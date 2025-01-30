extends Control

var current_line = 0
var interact_num = 0
# PUT ITEM VARIABLES IN INVENTORY MANAGER AND REFERENCE THEIR VALUES HERE
var has_item = false
var give_correct_item = false

# ARRAY SIZE = 2. CHANGE VALUES BASED ON NPC.
@export var intro_dialogue = []

@onready var start_dialogue = $"../Start Dialogue"
@onready var npc_dialogue = $"."
@onready var npc_text = $NPCText
@onready var next_button = $NextButton

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact") and start_dialogue.dialogue_finished:
		if interact_num == 0:
			npc_dialogue.show()
			#Freeze game except UI
			Engine.time_scale = 0
			initial_dialogue()
		if interact_num >= 1:
			npc_dialogue.show()
			#Freeze game except UI
			Engine.time_scale = 0
			branch_dialogue()


func initial_dialogue():
	if current_line < intro_dialogue.size():
		npc_text.text = intro_dialogue[current_line]
	else:
		#Hides initial dialogue
		npc_dialogue.hide()
		#Unfreeze game
		Engine.time_scale = 1
		interact_num = 1;


func branch_dialogue():
	if has_item:
		if give_correct_item:
			npc_text.text = "\"If I ever strike it rich, I'll send some gold your way.\""
		else:
			npc_text.text = "A displeased sign escapes her mouth."
	else:
		#Hides dialogue
		npc_dialogue.hide()
		#Unfreeze game
		Engine.time_scale = 1


func _on_continue_button_pressed() -> void:
	if interact_num == 0:
		current_line += 1
		initial_dialogue()
		
	if interact_num >= 1:
		branch_dialogue()
		
		if has_item:
			$DialogueShow.start()
			#Hides dialogue
			npc_dialogue.hide()
