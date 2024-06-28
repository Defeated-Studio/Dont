extends Node3D

@onready var player = %Player
@onready var player_head = %Player/Head
@onready var dialogue_text = %Player/DialogueText

@onready var quest_control = $"../QuestControl"

@onready var messages_app = $"../../../MessagesApp"
@onready var animation_player = $Notification/AnimationPlayer

@onready var first_date_2 = $"../../../MessagesApp/Mom/ScrollContainer/VBoxContainer/FirstDate2"
@onready var space_15 = $"../../../MessagesApp/Mom/ScrollContainer/VBoxContainer/Space15"
@onready var ninth_message_2 = $"../../../MessagesApp/Mom/ScrollContainer/VBoxContainer/NinthMessage2"
@onready var texture_rect = $"../../../MessagesApp/Mom/ScrollContainer/VBoxContainer/NinthMessage2/TextureRect"
@onready var no_signal = $"../../../MessagesApp/Mom/ScrollContainer/VBoxContainer/NinthMessage2/noSignal"
@onready var space_16 = $"../../../MessagesApp/Mom/ScrollContainer/VBoxContainer/Space16"

@onready var space_18 = $"../../../MessagesApp/Mom/ScrollContainer/VBoxContainer/Space18"
@onready var sixteenth_message_2 = $"../../../MessagesApp/Mom/ScrollContainer/VBoxContainer/SixteenthMessage2"
@onready var space_19 = $"../../../MessagesApp/Mom/ScrollContainer/VBoxContainer/Space19"
@onready var eleventh_message_3 = $"../../../MessagesApp/Mom/ScrollContainer/VBoxContainer/EleventhMessage3"

@onready var skin_walker = %SkinWalker

var canSendMom = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !player.onPath:
		skin_walker.following = true

		if !skin_walker.visible:
			skin_walker.global_position = player.global_position
			if player.rotation.y >= 0:
				skin_walker.global_position.x += 10	
			else:
				skin_walker.global_position.x -= 10	
			
			skin_walker.visible = true
	else:
		skin_walker.following = false
		skin_walker.visible = false
		
	if canSendMom and messages_app.triggerMomTask:
		canSendMom = false
		await get_tree().create_timer(1).timeout
		first_date_2.show()
		space_15.show()
		ninth_message_2.show()
		texture_rect.show()
		space_16.show()
		await get_tree().create_timer(1).timeout
		no_signal.show()
		await get_tree().create_timer(0.5).timeout
		dialogue_text.timeBetweenText = 3
		dialogue_text.queueDialogue("ainda sem sinal, claro")
		dialogue_text.queueDialogue("talvez em algum lugar alto da floresta eu consiga")
		dialogue_text.queueDialogue("essa floresta é assustadora, mas eu preciso ir")
		dialogue_text.showDialogue()


func _on_signal_area_body_entered(body):
	animation_player.play("newNotification")
	no_signal.hide()
	space_16.hide()
	space_18.show()
	sixteenth_message_2.show()
	await get_tree().create_timer(1).timeout
	space_19.show()
	eleventh_message_3.show()
	

func _on_trigger_task_body_entered(body):
	if quest_control.questActive == 10:
		quest_control.startQuest()
		dialogue_text.timeBetweenText = 3
		dialogue_text.queueDialogue("eu preciso de ajuda")
		dialogue_text.queueDialogue("vou tentar falar com a minha mãe")
		dialogue_text.showDialogue()
		canSendMom = true
		get_node("TriggerTask").queue_free()
		
func _on_navigation_agent_3d_target_reached():
	print("morreu")
