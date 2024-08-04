extends SubViewportContainer

@onready var states = $States
@onready var main_camera = $SubViewport/World/Player/Head/Camera3D
@onready var diary = %Diary
@onready var player = %Player
@onready var dialogue_text = %Player/DialogueText
@onready var couch_1 = %House/LivingRoom/Couch1
@onready var knifes = %House/Kitchen/Kitchen2/Knifes
@onready var messages_app = $MessagesApp

var pages = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	states.setStates()
	states.setPapersTaken()
	diary.add_page(pages)
	
	messages_app.updateMessages()
	
	main_camera.set_current(true)
	couch_1.position = Vector3(-0.116, 0.738, 3.188)
	couch_1.rotation_degrees = Vector3(0, 89.2, 0)
	knifes.hide()
	
	await get_tree().create_timer(2).timeout
	SaverLoader.save_game(5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

