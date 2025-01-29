extends StaticBody3D

class_name Item

static var ASSIGN_ID := 100

signal item_changed(item_id:int, flag_name:String, flag_value:bool)

const show_ui = "Show UI"
const level = "Level"
const spawned = "Spawned"
const in_inventory = "In Inventory"
const used = "Used"



enum TYPE {
	CASH = 0,
	KOMPROMAT = 1,
	TICKET = 2
}

@export var type : TYPE

@onready var show_ui_value = false
@export var level_value : String
@onready var spawned_value : bool
@onready var in_inventory_value : bool
@onready var used_value : bool
var id :int

@onready var interact_text = $InteractText

func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE
	id = ASSIGN_ID
	ASSIGN_ID += 1
