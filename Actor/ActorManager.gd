extends Node

class_name ActorManager

@onready var actor_ui = $ActorUI

var speaking_actor:Actor

const speaker_name = "Name"
const speech = "Speech"
const description = "Description"
const responses = "Responses"
const text = "Text"
const next_dialog_id = "NextDialogID"

const cash = "Cash"
const kompromat = "Kompromat"
const ticket = "Ticket"

signal scene_finished(actor:Actor)

@onready var actor_name : RichTextLabel = $ActorUI/MarginContainer/ActorName
@onready var description_box : RichTextLabel = $ActorUI/MarginContainer/DescriptionBox
@onready var speech_box : RichTextLabel = $ActorUI/MarginContainer/DialogBox
@onready var response_buttons : Array[Button] = [$"ActorUI/MarginContainer/0", $"ActorUI/MarginContainer/1", $"ActorUI/MarginContainer/2", $"ActorUI/MarginContainer/3"]

var actor_name_pos
var description_box_pos
var speech_box_pos


const NULL_ID = -1
@onready var present_actors = $PresentActors

@onready var player = %Player
const show_ui = "Show UI"
const object = "Object"

var actor_dict : Dictionary


var show_pick_up_text = false

signal player_near_actor(actor_id:int)

func _ready():
	actor_name_pos = actor_name.position
	description_box_pos = description_box.position
	speech_box_pos = speech_box.position
	for i in range(0, present_actors.get_child_count()):
		var actor : Actor = present_actors.get_child(i)
		actor_dict[actor.id] = actor
	player.start_dialog.connect(_on_start_dialog)
	player.continue_dialog.connect(_on_continue_dialog)

	response_buttons[0].pressed.connect(on_press_button_0)
	response_buttons[1].pressed.connect(on_press_button_1)
	response_buttons[2].pressed.connect(on_press_button_2)
	response_buttons[3].pressed.connect(on_press_button_3)

func _on_start_dialog(id:int):
	if id != NULL_ID && !player.is_in_dialog:
		speaking_actor = actor_dict[id]
		player.is_in_dialog = true
		var scene_id = str(speaking_actor.scene_id)
		var dialog_id = str(speaking_actor.dialog_id)
		var conversation = speaking_actor.dialog_scenes[scene_id][dialog_id]
		display_name(conversation)
		display_description(conversation)
		display_speech(conversation)
		#speaking_actor.dialog_id = conversation["NextDialogID"]
		display_buttons(conversation)
		actor_ui.visible = true
		Engine.time_scale = 0

func _on_continue_dialog(choice:String):
	var scene_id = str(speaking_actor.scene_id)
	var dialog_id = str(speaking_actor.dialog_id)
	var conversation = speaking_actor.dialog_scenes[scene_id][dialog_id]
	if "Score" in conversation[responses][choice].keys():
		player.score += conversation[responses][choice]["Score"]
	print("Player Score: %d" % player.score)
	speaking_actor.dialog_id = conversation[responses][choice][next_dialog_id]
	if speaking_actor.dialog_id != NULL_ID:
		scene_id = str(speaking_actor.scene_id)
		dialog_id = str(speaking_actor.dialog_id)
		conversation = speaking_actor.dialog_scenes[scene_id][dialog_id]
		display_name(conversation)
		display_description(conversation)
		display_speech(conversation)
		display_buttons(conversation)		
	else:
		speaking_actor.dialog_id = 0
		actor_ui.visible = false
		actor_name.text = ""
		speech_box.text = ""
		hide_buttons()
		scene_finished.emit(speaking_actor)
		Engine.time_scale = 1
		player.is_in_dialog = false

func display_name(conversation:Dictionary) -> void:
	if speaker_name in conversation.keys():
		actor_name.position = actor_name_pos
		actor_name.custom_minimum_size = Vector2(0,24)
		actor_name.text = conversation[speaker_name]
		actor_name.visible = true
	else:
		actor_name.custom_minimum_size = Vector2(0,0)
		actor_name.text = ""
		actor_name.visible = false

func display_description(conversation:Dictionary) -> void:
	if description in conversation.keys():
		if speaker_name not in conversation.keys():
			description_box.position = actor_name_pos
		else:
			description_box.position = description_box_pos
		description_box.custom_minimum_size = Vector2(0,24)
		description_box.text = conversation[description]
		description_box.visible = true
	else:
		description_box.custom_minimum_size = Vector2(0,24)
		description_box.text = ""
		description_box.visible = false

func display_speech(conversation:Dictionary) -> void:
	if speech in conversation.keys():
		if speaker_name not in conversation.keys() && description not in conversation.keys():
			speech_box.position = actor_name_pos
		elif description not in conversation.keys():
			speech_box.position = description_box_pos
		else:
			speech_box.position = speech_box_pos
		speech_box.custom_minimum_size = Vector2(0,24)
		speech_box.text = conversation[speech]
		speech_box.visible = true
	else:
		speech_box.custom_minimum_size = Vector2(0,0)
		speech_box.text = ""
		speech_box.visible = false

func display_buttons(conversation:Dictionary) -> void:
	var num_of_responses = conversation[responses].size()
	if num_of_responses == 1:
		var button : Button = response_buttons[0]
		button.custom_minimum_size = Vector2(0,24)
		button.text = conversation[responses][button.name][text]
		button.visible = true
		for i in range(1,response_buttons.size()):
			response_buttons[i].custom_minimum_size = Vector2(0,0)
			response_buttons[i].text = ""
			response_buttons[i].visible = false
	else:
		for i in range(0, response_buttons.size()):
			var button : Button = response_buttons[i]
			if button.name in conversation[responses].keys():
				if i < 3:
					if player.inventory[i]:
						button.custom_minimum_size = Vector2(0,24)
						button.text = conversation[responses][button.name][text]
						button.visible = true
				else:
					button.custom_minimum_size = Vector2(0,24)
					button.text = conversation[responses][button.name][text]
					button.visible = true
			else:
				button.custom_minimum_size = Vector2(0,0)
				button.text = ""
				button.visible = false

func hide_buttons() -> void:
	for button in response_buttons:
		button.custom_minimum_size = Vector2(0,0)
		button.text = ""
		button.visible = false

func update_actor_dict(id:int, flag_name:String, flag_value:bool) -> void:
	if id in actor_dict:
		actor_dict[id][flag_name] = flag_value
	
	check_show_ui()

func check_show_ui() -> void:
	for id in actor_dict:
		if actor_dict[id]:
			speech_box.visible = true
			return
	speech_box.visible = false
	
func delete_items() -> void:
	pick_up_multiple_at_time()
	
func pick_up_one_at_time() -> void:	
	for id in actor_dict:
		if actor_dict[id]:
			var actor : Actor = actor_dict[id][object]
			actor.queue_free()
			actor_dict.erase(id)


func pick_up_multiple_at_time() -> void:
	var delete_array :Array[int] = []
	for id in actor_dict:
		delete_array.append(id)
	
	for id in delete_array:
		if actor_dict[id]:
			var actor : Actor = actor_dict[id][object]
			actor.queue_free()
			actor_dict.erase(id)

func on_press_button_0():
	handle_inventory_and_score(0)
	_on_continue_dialog(str(0))

func on_press_button_1():
	handle_inventory_and_score(1)
	_on_continue_dialog(str(1))

func on_press_button_2():
	handle_inventory_and_score(2)
	_on_continue_dialog(str(2))

func on_press_button_3():
	handle_inventory_and_score(3)
	_on_continue_dialog(str(3))

func handle_inventory_and_score(id:int):
	var button:Button = response_buttons[id]
	if cash in button.text:
		speaking_actor.has_item = true
		player.inventory[Item.TYPE.CASH] = false
		if speaking_actor.name == "Gus":
			speaking_actor.has_correct_item = true
			var gus :Gus = speaking_actor
			gus.current_state = Gus.State.final
	elif kompromat in button.text:
		speaking_actor.has_item = true
		player.inventory[Item.TYPE.KOMPROMAT] = false
		if speaking_actor.name == "Cassie":
			speaking_actor.has_correct_item = true
			var cassie :Cassie = speaking_actor
			cassie.current_state = Cassie.State.final
	elif ticket in button.text:
		speaking_actor.has_item = true
		player.inventory[Item.TYPE.TICKET] = false
		if speaking_actor.name == "Abigale":
			speaking_actor.has_correct_item = true
			var abigale :Abigale = speaking_actor
			abigale.current_state = Abigale.State.final
