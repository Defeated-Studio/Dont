extends SubViewportContainer

@onready var states = $States
@onready var main_camera = $SubViewport/World/Player/Head/Camera3D
@onready var diary = %Diary
@onready var quest_control = $SubViewport/World/QuestControl

var pages = 1

func _ready():
	states.setStates()
	states.setPapersTaken()
	
	diary.add_page(pages)
	
	main_camera.set_current(true)
	
	quest_control.setQuestActive(4)
	
	await get_tree().create_timer(2).timeout
	SaverLoader.save_game(2)
