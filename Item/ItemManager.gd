extends Node

class_name ItemManager

@onready var item_ui = $ItemUI
@onready var pick_up_text = $"ItemUI/Pick Up Text"
@onready var present_items = $PresentItems

@onready var player = $"../Player"
const show_ui = "Show UI"
const object = "Object"

var item_dict : Dictionary


var show_pick_up_text = false

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(0, present_items.get_child_count()):
		var item:Item = present_items.get_child(i)
		item.item_changed.connect(update_item_dict)
		
		var item_properties :Dictionary
		item_properties[show_ui] = item.show_ui_value
		item_properties[object] = item
		
		item_dict[item.id] = item_properties
	
	player.pick_up_items.connect(delete_items)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_item_dict(item_id:int, flag_name:String, flag_value:bool) -> void:
	if item_id in item_dict:
		item_dict[item_id][flag_name] = flag_value
	
	check_show_ui()

func check_show_ui() -> void:
	for id in item_dict:
		if item_dict[id][show_ui]:
			pick_up_text.visible = true
			return
	pick_up_text.visible = false
	
func delete_items() -> void:
	pick_up_multiple_at_time()
	
func pick_up_one_at_time() -> void:	
	for id in item_dict:
		if item_dict[id][show_ui]:
			var item : Item = item_dict[id][object]
			item.queue_free()
			item_dict.erase(id)


func pick_up_multiple_at_time() -> void:
	var delete_array :Array[int] = []
	for id in item_dict:
		delete_array.append(id)
	
	for id in delete_array:
		if item_dict[id][show_ui]:
			var item : Item = item_dict[id][object]
			item.queue_free()
			item_dict.erase(id)
