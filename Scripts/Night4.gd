extends SubViewportContainer

@onready var states = $States
@onready var main_camera = $SubViewport/World/Player/Head/Camera3D
@onready var diary = %Diary
@onready var rain = $rain

# Called when the node enters the scene tree for the first time.
func _ready():
	rain.play()
	states.setStates()
	states.setPapersTaken()
	diary.add_page()
	main_camera.set_current(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
