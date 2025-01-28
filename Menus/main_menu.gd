extends Control


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")


func _on_controls_pressed() -> void:
	get_tree().change_scene_to_file("res://Menus/controls_menu.tscn")


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://Menus/settings_menu.tscn")


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://Menus/credits_menu.tscn")
