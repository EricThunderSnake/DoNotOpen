extends StaticBody3D

class_name Item

static var ASSIGN_ID := 0

signal item_changed(item_id:int, flag_name:String, flag_value:bool)

const show_ui = "Show UI"

@onready var interact_area:Area3D = $Area3D
@onready var show_ui_value = false
var id :int



func _ready():
	id = ASSIGN_ID
	ASSIGN_ID += 1
	interact_area.body_entered.connect(on_body_enter)
	interact_area.body_exited.connect(on_body_exit)
	
func on_body_enter(body:Node3D) -> void:
	if body.name == "Player":
	# TODO: check body is player, otherwise NPCs will wreak havoc on UI
		show_ui_value = true
		item_changed.emit(id, show_ui, show_ui_value)

func on_body_exit(body:Node3D) -> void:
	# Area always centred at item, so no need to check for self collision
	show_ui_value = false
	item_changed.emit(id, show_ui, show_ui_value)
