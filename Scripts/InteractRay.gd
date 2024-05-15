extends RayCast3D


@onready var default_crosshair = $Control/DefaultCrosshair
@onready var interact_crosshair = $Control/InteractCrosshair


func _ready():
	add_exception(owner)


func _process(delta):
	var collider = get_collider()
	default_crosshair.show()
	interact_crosshair.hide()
	IsRayCasting.canInteract = false
	if collider is Node:
		if collider.is_in_group("InteractGroup"):
			IsRayCasting.canInteract = true
			default_crosshair.hide()
			interact_crosshair.show()
