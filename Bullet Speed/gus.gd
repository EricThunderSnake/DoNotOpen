extends CharacterBody3D

@onready var animated_sprite_3D = $AnimatedSprite3D

enum State {idle,final}

var current_state : State

#On launch
func _ready():
	current_state = State.idle


func _physics_process(delta: float):
	
	_gus_animation()

func _gus_animation():
	if current_state == State.idle:
		animated_sprite_3D.play("idle")
	elif current_state == State.final:
		animated_sprite_3D.play("final")
