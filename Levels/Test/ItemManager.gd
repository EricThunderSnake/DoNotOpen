extends Node

@onready var item_ui = $ItemUI
@onready var pick_up_text = $"ItemUI/Pick Up Text"
@onready var present_items = $PresentItems



const show_ui = "Show UI"

var item_dict : Dictionary


var show_pick_up_text = false

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(0, present_items.get_child_count()):
		var item:Item = present_items.get_child(i)
		item.item_changed.connect(update_item_dict)
		
		var item_flags :Dictionary
		item_flags[show_ui] = item.show_ui_value
		
		item_dict[item.id] = item_flags
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_item_dict(item_id:int, flag_name:String, flag_value:bool) -> void:
	item_dict[item_id][flag_name] = flag_value
	check_show_ui()

func check_show_ui() -> void:
	for id in item_dict:
		if item_dict[id][show_ui]:
			pick_up_text.visible = true
			return
	pick_up_text.visible = false
