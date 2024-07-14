extends SubViewportContainer

@onready var states = $States
@onready var main_camera = $SubViewport/World/Player/Head/Camera3D
@onready var diary = %Diary

@onready var dialogue_text = $SubViewport/World/Player/DialogueText

# Called when the node enters the scene tree for the first time.
func _ready():
	states.setStates()
	states.setPapersTaken()
	diary.add_page()
	main_camera.set_current(true)

	dialogue_text.timeBetweenText = 3
	dialogue_text.queueDialogue("eu preciso de ajuda o mais rápido possível, eu não to aguentando mais")
	dialogue_text.showDialogue()
