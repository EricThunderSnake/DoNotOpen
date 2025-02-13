extends Node




@onready var item_manager :ItemManager= $ItemManager
@onready var actor_manager :ActorManager= $ActorManager

@export var objective_dictionary:Dictionary

@onready var player = %Player
@onready var cassie = $ActorManager/PresentActors/Cassie
@onready var abigale = $ActorManager/PresentActors/Abigale
@onready var gus = $ActorManager/PresentActors/Gus

@onready var pause_menu = $"../Pause Menu"

@onready var ending_good = $"../EndingGood"
@onready var ending_bad = $"../EndingBad"
# Called when the node enters the scene tree for the first time.
func _ready():
	actor_manager.scene_finished.connect(_update_scenario)
	
func _update_scenario(actor:Actor) -> void:
	if actor.dialog_scenes.size() == 1:
		pass
	elif actor.scene_id == 0 :
		actor.scene_id += 1
	else:
		actor.interact_text.visible = false
		player.actor_id = player.NULL_ID
		if gus.has_item && cassie.has_item && abigale.has_item:
			get_parent().remove_child(pause_menu)
			Engine.time_scale = 0
			if gus.has_correct_item && cassie.has_correct_item && abigale.has_correct_item:
				ending_good.visible = true
			else:
				ending_bad.visible = true
