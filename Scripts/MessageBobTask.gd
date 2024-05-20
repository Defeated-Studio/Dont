extends Node3D

@onready var quest_control = $"../QuestControl"
@onready var player_dialogue = $"../Player/DialogueText"
@onready var interact_text = $"../InteractText/InteractText"
@onready var messages_app = $"../../../MessagesApp"

var canShow = true

func _ready():
	$"../../../MessagesApp/Bob/ScrollContainer/VBoxContainer/SecondDate".hide()
	$"../../../MessagesApp/Bob/ScrollContainer/VBoxContainer/Space25".hide()
	$"../../../MessagesApp/Bob/ScrollContainer/VBoxContainer/Message23".hide()
	$"../../../MessagesApp/Bob/ScrollContainer/VBoxContainer/Space23".hide()
	$"../../../MessagesApp/Bob/ScrollContainer/VBoxContainer/Space24".hide()
	$"../../../MessagesApp/Bob/ScrollContainer/VBoxContainer/Message24".hide()
	$"../../../MessagesApp/Bob/ScrollContainer/VBoxContainer/Space28".hide()
	$"../../../MessagesApp/Bob/ScrollContainer/VBoxContainer/Message23/noSignal".hide()
	$"../../../MessagesApp/Bob/ScrollContainer/VBoxContainer/noSignal2".hide()
	$"../../../MessagesApp/Bob/ScrollContainer/VBoxContainer/Space27".hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if messages_app.finishedTexting:
		if interact_text.visible:
			interact_text.hide()
		messages_app.finishedTexting = false
		await get_tree().create_timer(0.5).timeout
		player_dialogue.timeBetweenText = 2
		player_dialogue.queueDialogue("sem sinal? sério")
		player_dialogue.queueDialogue("isso só pode ser um pesadelo")
		player_dialogue.showDialogue()
		quest_control.finishQuest()
	
	if quest_control.questActive == 2:
		if canShow:
			showInteractText()
		if Input.is_action_just_pressed("Mobile"):
			interact_text.hide()
		if messages_app.inBobWindow:
			messages_app.sendBobMessages()
			messages_app.inBobWindow = false

func showInteractText():
	canShow = false
	await get_tree().create_timer(10).timeout
	interact_text.text = "[M] Abrir Celular"
	interact_text.show()
