extends RayCast3D
@onready var player = $"../.."

func _process(delta):
	var collider = get_collider()
	if collider != null and collider.is_in_group("Wood"):
		player.ground = "Wood"
		player.onPath = true
		
	elif collider != null and collider.name == "Terrain3D":
		player.ground = "Grass"
		
		if collider.get_storage().get_texture_id(player.global_position)[0] == 1:
			player.onPath = true
		else:
			player.onPath = false
