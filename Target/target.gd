extends Area3D

class_name Target

@export var next_target: Target

func SetNextTarget(new_target : Target) -> void:
	self.next_target = new_target

static func GetNextTarget(current_target:Target) -> Target:
	return current_target.next_target

static func GetName(target:Target) -> String:
	if target == null:
		return "null"
	else:
		return target.name

static func GetPosition(target:Target) -> Vector3:
	if target.get_parent().name == "Player":
		return target.get_parent().position
	else:
		return target.position

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
