extends RayCast3D


@onready var default_crosshair = $Control/DefaultCrosshair
@onready var interact_crosshair = $Control/InteractCrosshair


func _ready():
	add_exception(owner)


func _process(delta):
	IsRayCasting.collider = get_collider()
	default_crosshair.show()
	interact_crosshair.hide()
	IsRayCasting.canInteract = false
	
	if IsRayCasting.collider is Node:
		if (IsRayCasting.collider.is_in_group("InteractGroup") and IsRayCasting.collider.is_visible_in_tree()):
			if IsRayCasting.collider.name == "PeepHoleRay":
				default_crosshair.hide()
				interact_crosshair.show()
				IsRayCasting.canInteract = true
				interact_crosshair.label_settings.font_color = Color(0, 0.575, 0.173)
			else:
				interact_crosshair.label_settings.font_color = Color(1, 1, 0)
				IsRayCasting.canInteract = true
				default_crosshair.hide()
				interact_crosshair.show()
