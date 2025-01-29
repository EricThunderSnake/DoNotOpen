extends Node




@onready var item_manager :ItemManager= $ItemManager
@onready var actor_manager :ActorManager= $ActorManager

@export var objective_dictionary:Dictionary



# Called when the node enters the scene tree for the first time.
func _ready():
	actor_manager.scene_finished.connect(_update_scenario)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _update_scenario(actor:Actor) -> void:
	if actor.dialog_scenes.size() == 1:
		pass
	elif actor.scene_id == 0 :
		actor.scene_id += 1
