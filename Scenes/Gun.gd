extends Node3D

@export var Bullet:PackedScene

@onready var rof_timer = $Timer

@export var muzzle_speed = 30
@export var millis_between_shots = 0.1

var can_shoot = true

func _ready():
	rof_timer.wait_time = millis_between_shots

func shoot():
	if can_shoot:
	
		var new_bullet = Bullet.instantiate()
		new_bullet.global_transform = $Muzzle.global_transform
		new_bullet.speed = muzzle_speed
		var scene_root = get_tree().current_scene
		scene_root.add_child(new_bullet)
		print("pew!")
		can_shoot = false
		rof_timer.start()
	

func _on_timer_timeout():
	print("shoot true")
	can_shoot = true
