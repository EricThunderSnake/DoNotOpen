class_name Cassie extends Actor

@onready var animated_sprite_3D = $AnimatedSprite3D

enum State {idle,final}

var current_state : State

#On launch
func _ready():
	super._ready()
	current_state = State.idle


func _physics_process(delta: float):
	_cassie_animation()

func _cassie_animation():
	if current_state == State.idle:
		animated_sprite_3D.play("idle")
	elif current_state == State.final:
		animated_sprite_3D.play("final")
