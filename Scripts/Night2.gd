extends SubViewportContainer

@onready var states = $States
@onready var main_camera = $SubViewport/World/Player/Head/Camera3D
@onready var diary = %Diary


func _ready():
	states.setStates()
	states.setPapersTaken()
	diary.add_page()
	diary.toggle_visibility()
	main_camera.set_current(true)
