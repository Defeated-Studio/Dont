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
		player_dialogue.timeBetweenText = 3
		player_dialogue.queueDialogue("sem sinal? sério")
		player_dialogue.queueDialogue("isso só pode ser um pesadelo")
		player_dialogue.showDialogue()
		quest_control.finishQuest()
		self.queue_free()
			
	if Input.is_action_just_pressed("Mobile"):
		interact_text.hide()
	if messages_app.inBobWindow and quest_control.questActive == 1:
		messages_app.sendBobMessages()
		messages_app.inBobWindow = false

func showInteractText():
	canShow = false
	await get_tree().create_timer(10).timeout
	interact_text.text = "[M] Abrir Celular"
	interact_text.show()


func _on_trigger_message_bob_task_body_entered(body):
	if quest_control.questActive == 1:
		player_dialogue.timeBetweenText = 3
		player_dialogue.queueDialogue("essa casa não parece certa, sinto algo estranho.")
		player_dialogue.queueDialogue("posso jurar que as fotos do anúncio estavam diferentes")
		player_dialogue.queueDialogue("vou chamar o bob e resolver isso")
		player_dialogue.showDialogue()
		quest_control.startQuest()
		showInteractText()
		get_node("TriggerMessageBobTask").queue_free()
