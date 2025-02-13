extends AudioStreamPlayer

@onready var obstacle = $"../Obstacle"

# Called when the node enters the scene tree for the first time.
func _ready():
	print(volume_db)
	obstacle.on_destroy.connect(play)
