extends SubViewportContainer

@onready var states = $States
@onready var main_camera = $SubViewport/World/Player/Head/Camera3D
@onready var diary = %Diary
@onready var rain = $rain
@onready var player = %Player
@onready var dialogue_text = %Player/DialogueText
@onready var forest_nav = %ForestNav
@onready var quest_control = $SubViewport/World/QuestControl
@onready var messages_app = $MessagesApp

var pages = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	forest_nav.enabled = false
	rain.play()
	
	states.setStates()
	states.setPapersTaken()
	states.setMicSensi()
	
	messages_app.updateMessages()
	
	diary.add_page(pages)
	quest_control.setQuestActive(14)
	main_camera.set_current(true)
	
	await get_tree().create_timer(2).timeout
	SaverLoader.save_game(4)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_dont_go_outside_body_entered(body):
	if body.name != "Mom":
		dialogue_text.timeBetweenText = 3.5
		dialogue_text.queueDialogue("melhor eu não sair nessa chuva")
		dialogue_text.showDialogue()


