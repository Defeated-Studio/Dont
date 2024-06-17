extends RayCast3D
@onready var player = $"../.."

func _process(delta):
	var collider = get_collider()
	if collider != null and collider.is_in_group("Wood"):
		player.ground = "Wood"
	elif collider != null and collider.name == "Terrain3D":
		player.ground = "Grass"
