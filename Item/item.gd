extends StaticBody3D

class_name Item

static var ASSIGN_ID := 0

signal item_changed(item_id:int, flag_name:String, flag_value:bool)


const show_ui = "Show UI"


@onready var show_ui_value = false
var id :int

@onready var interact_text = $InteractText

func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE
	id = ASSIGN_ID
	ASSIGN_ID += 1
