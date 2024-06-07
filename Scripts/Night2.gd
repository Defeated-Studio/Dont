extends SubViewportContainer

@onready var states = $States
@onready var main_camera = $SubViewport/World/Player/Head/Camera3D


# Called when the node enters the scene tree for the first time.
func _ready():
	states.setStates()
	main_camera.set_current(true)
