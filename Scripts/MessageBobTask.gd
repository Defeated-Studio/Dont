extends Node3D

@onready var quest_control = $"../QuestControl"
@onready var player_dialogue = $"../Player/DialogueText"
@onready var interact_text = $"../InteractText/InteractText"
@onready var messages_app = $"../../../MessagesApp"

@onready var second_date = $"../../../MessagesApp/Bob/ScrollContainer/VBoxContainer/SecondDate"
@onready var space_25 = $"../../../MessagesApp/Bob/ScrollContainer/VBoxContainer/Space25"
@onready var message_23 = $"../../../MessagesApp/Bob/ScrollContainer/VBoxContainer/Message23"
@onready var space_23 = $"../../../MessagesApp/Bob/ScrollContainer/VBoxContainer/Space23"
@onready var space_24 = $"../../../MessagesApp/Bob/ScrollContainer/VBoxContainer/Space24"
@onready var message_24 = $"../../../MessagesApp/Bob/ScrollContainer/VBoxContainer/Message24"
@onready var space_28 = $"../../../MessagesApp/Bob/ScrollContainer/VBoxContainer/Space28"
@onready var no_signal = $"../../../MessagesApp/Bob/ScrollContainer/VBoxContainer/Message23/noSignal"
@onready var no_signal_2 = $"../../../MessagesApp/Bob/ScrollContainer/VBoxContainer/noSignal2"
@onready var space_27 = $"../../../MessagesApp/Bob/ScrollContainer/VBoxContainer/Space27"

@onready var scrollbar = $"../../../MessagesApp/Bob/ScrollContainer".get_v_scroll_bar()
@onready var scrollbarValue = $"../../../MessagesApp/Bob/ScrollContainer"
var max_scroll_length = 0 
var finishedTexting = false
var canShow = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if finishedTexting:
		if interact_text.visible:
			interact_text.hide()
		finishedTexting = false
		await get_tree().create_timer(0.5).timeout
		player_dialogue.timeBetweenText = 2
		player_dialogue.queueDialogue("sem sinal? sério")
		player_dialogue.queueDialogue("isso só pode ser um pesadelo")
		player_dialogue.showDialogue()
		quest_control.finishQuest()
	
	if max_scroll_length != scrollbar.max_value: 
		max_scroll_length = scrollbar.max_value
		scrollbarValue.scroll_vertical = max_scroll_length
	
	
	if quest_control.questActive == 2:
		if canShow:
			showInteractText()
		if Input.is_action_just_pressed("Mobile"):
			interact_text.hide()
		if messages_app.inBobWindow:
			sendBobMessages()
			messages_app.inBobWindow = false


func showInteractText():
	canShow = false
	await get_tree().create_timer(10).timeout
	interact_text.text = "[M] Abrir Celular"
	interact_text.show()

func sendBobMessages():
	await get_tree().create_timer(1.2).timeout
	second_date.show()
	space_25.show()
	message_23.show()
	space_23.show()
	await get_tree().create_timer(1.2).timeout
	no_signal.show()
	space_24.show()
	await get_tree().create_timer(2).timeout
	message_24.show()
	space_28.show()
	await get_tree().create_timer(1.2).timeout
	no_signal_2.show()
	space_27.show()
	finishedTexting = true
