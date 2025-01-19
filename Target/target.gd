extends Area3D

class_name Target

@export var next_target: Target

static func GetNextTarget(current_target:Target) -> Target:
	return current_target.next_target



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
