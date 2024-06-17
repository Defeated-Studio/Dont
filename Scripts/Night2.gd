extends SubViewportContainer

@onready var states = $States
@onready var main_camera = $SubViewport/World/Player/Head/Camera3D
@onready var diary = %Diary


# Called when the node enters the scene tree for the first time.
func _ready():
	states.setStates()
	states.setPapersTaken()
	diary.add_page()
	main_camera.set_current(true)
