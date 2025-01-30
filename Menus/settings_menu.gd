extends Control

func _ready():
	$"Volume/Master Volume".value = db_to_linear(AudioServer.get_bus_volume_db(0))
	$"Volume/Music Volume".value = db_to_linear(AudioServer.get_bus_volume_db(1))
	$"Volume/SFX Volume".value = db_to_linear(AudioServer.get_bus_volume_db(2))


func _on_sfx_volume_mouse_exited() -> void:
	release_focus()


func _on_music_volume_mouse_exited() -> void:
	release_focus()


func _on_master_volume_mouse_exited() -> void:
	release_focus()

func _on_confirm_pressed() -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db($"Volume/Master Volume".value))
	AudioServer.set_bus_volume_db(1, linear_to_db($"Volume/Music Volume".value))
	AudioServer.set_bus_volume_db(2, linear_to_db($"Volume/SFX Volume".value))
