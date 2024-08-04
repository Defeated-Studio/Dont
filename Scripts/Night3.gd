extends SubViewportContainer

@onready var states = $States
@onready var main_camera = $SubViewport/World/Player/Head/Camera3D
@onready var diary = %Diary

@onready var dialogue_text = $SubViewport/World/Player/DialogueText
@onready var quest_control = $SubViewport/World/QuestControl

var pages = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	states.setStates()
	states.setPapersTaken()
	diary.add_page(pages)
	main_camera.set_current(true)
	
	quest_control.setQuestActive(10)

	dialogue_text.timeBetweenText = 5
	dialogue_text.queueDialogue("eu preciso de ajuda o mais rápido possível, eu não to aguentando mais")
	dialogue_text.showDialogue()

	await get_tree().create_timer(2).timeout
	SaverLoader.save_game(3)
