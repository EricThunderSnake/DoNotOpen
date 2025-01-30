extends RigidBody3D

@onready var explosion: Node3D = $Explosion

@onready var area_3d: Area3D = $Area3D

@onready var collision_shape = $Area3D/CollisionShape3D
@onready var mesh_instance = $MeshInstance3D
@export var is_destroyable : bool = true  # true: can be destroyed
@export var dash_damage : float = 1.0  # dash damage
@onready var player = null

func _ready():
	
	area_3d.body_entered.connect(_on_body_entered)
	player = get_node("../Player")  # Remplace "/root/Scene/Player" par le chemin correct du joueur
	#player.dash_started.connect._on_dash_started()

func _on_dash_started():
	# Destroy object
	if is_destroyable:
		queue_free()
		print("Obstacle destroyed by dash!")


# collision check
#func _on_area_entered(area: Area3D) -> void:
	#if area.is_in_group("player") and area.has_method("start_dash"):
		#var player = area
		#if player.current_state == "dash":
			#if is_destroyable:
				#queue_free()  # Destroy object
				#print("Obstacle destroyed by dash!")


#func _on_area_3d_area_entered(area: Area3D) -> void:
	


func _on_body_entered(body: Node3D) -> void:
	print("area 3D")
	if body is Player:
		print("Body is player")
		var player := body
		if player.current_state == Player.State.dash:
			if is_destroyable:
				explosion.show()
				queue_free()  # Destroy object
				print("Obstacle destroyed by dash!") # Replace with function body.
