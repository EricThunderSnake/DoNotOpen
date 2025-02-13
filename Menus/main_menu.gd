extends Node

@onready var main_menu = $"Main Menu"
@onready var start = $"Main Menu/VBoxContainer/Start"
@onready var controls_button = $"Main Menu/VBoxContainer/Controls"

@onready var credits_button = $"Main Menu/VBoxContainer/Credits"
@onready var controls_back = $Controls/Back
@onready var credits_back = $Credits/Back
@onready var controls = $Controls
@onready var credits = $Credits

func _ready():
	start.pressed.connect(_on_start_pressed)
	controls_button.pressed.connect(_on_controls_pressed)
	credits_button.pressed.connect(_on_credits_pressed)
	controls_back.pressed.connect(_on_controls_back_pressed)
	credits_back.pressed.connect(_on_credits_back_pressed)

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Game/interior.tscn")


func _on_controls_pressed() -> void:
	main_menu.visible = false
	controls.visible = true


func _on_credits_pressed() -> void:
	main_menu.visible = false
	credits.visible = true
	
func _on_controls_back_pressed() -> void:
	controls.visible = false
	main_menu.visible = true

func _on_credits_back_pressed() -> void:
	credits.visible = false
	main_menu.visible = true
	
