extends Node

class_name ActorManager

@onready var actor_ui = $ActorUI

var current_scene_info:Dictionary ={"scene_id":0,"dialog_id":0}
var speaking_actor:Actor

@onready var actor_name : RichTextLabel = $ActorUI/ActorName
@onready var dialog_box : RichTextLabel = $ActorUI/DialogBox
###############################################################################
@onready var player_response : RichTextLabel = $ActorUI/PlayerResponse # Unused
###############################################################################
const NULL_ID = -1
@onready var present_actors = $PresentActors

@onready var player = $"../Player"
const show_ui = "Show UI"
const object = "Object"

var actor_dict : Dictionary


var show_pick_up_text = false

signal player_near_actor(actor_id:int)

func _ready():
	for i in range(0, present_actors.get_child_count()):
		var actor : Actor = present_actors.get_child(i)
		#item.item_changed.connect(update_item_dict)
		var actor_properties :Dictionary
		actor_dict[actor.id] = actor
	player.start_dialog.connect(_on_start_dialog)
	player.continue_dialog.connect(_on_continue_dialog)
	

func _on_start_dialog(id:int):
	if id != NULL_ID && !player.is_in_dialog:
		player.is_in_dialog = true
		
		speaking_actor = actor_dict[id]
		var scene_id = str(speaking_actor.scene_id)
		var dialog_id = str(speaking_actor.dialog_id)
		actor_name.text = speaking_actor.dialog_scenes[scene_id][dialog_id]["Name"]
		dialog_box.text = speaking_actor.dialog_scenes[scene_id][dialog_id]["Speech"]
		speaking_actor.dialog_id = speaking_actor.dialog_scenes[scene_id][dialog_id]["NextDialogID"]
		actor_ui.visible = true
		get_tree().paused = true

func _on_continue_dialog():
	if speaking_actor.dialog_id != NULL_ID:
		var scene_id = str(speaking_actor.scene_id)
		var dialog_id = str(speaking_actor.dialog_id)
		actor_name.text = speaking_actor.dialog_scenes[scene_id][dialog_id]["Name"]
		dialog_box.text = speaking_actor.dialog_scenes[scene_id][dialog_id]["Speech"]
		speaking_actor.dialog_id = speaking_actor.dialog_scenes[scene_id][dialog_id]["NextDialogID"]
	else:
		if speaking_actor.scene_id + 1 == speaking_actor.dialog_scenes.size():
			player.start_dialog.disconnect(_on_start_dialog)
			actor_ui.queue_free()
			speaking_actor.interact_text.queue_free()
		speaking_actor.scene_id += 1
		speaking_actor.dialog_id = 0
		actor_ui.visible = false
		actor_name.text = ""
		dialog_box.text = ""
		get_tree().paused = false
		player.is_in_dialog = false
		


func update_actor_dict(id:int, flag_name:String, flag_value:bool) -> void:
	if id in actor_dict:
		actor_dict[id][flag_name] = flag_value
	
	check_show_ui()

func check_show_ui() -> void:
	for id in actor_dict:
		if actor_dict[id]:
			dialog_box.visible = true
			return
	dialog_box.visible = false
	
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
