extends Node3D

@onready var player = %Player
@onready var player_head = %Player/Head
@onready var dialogue_text = %Player/DialogueText
@onready var interact_ray = %Player/Head/InteractRay

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

@onready var no_signal_bob = $"../../../MessagesApp/Bob/ScrollContainer/VBoxContainer/Message23/noSignal"
@onready var no_signal_2_bob = $"../../../MessagesApp/Bob/ScrollContainer/VBoxContainer/noSignal2"

@onready var skin_walker = %SkinWalker
@onready var death = $"../../../Death"
@onready var notification_sound = $NotificationSound
@onready var static_body_3d = $StaticBody3D

@onready var soundtrack = $"../../../Soundtrack3"
@onready var first_soundtrack = $"../../../Soundtrack3/FirstSoundtrack"

var canSendMom = false


func _ready():
	soundtrack.fadeInAudio(first_soundtrack, 8)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !player.onPath:
		interact_ray.target_position.z = -10
		skin_walker.following = true

		if (player.speed != player.WALK_SPEED or IsRayCasting.canInteract && IsRayCasting.collider.name == 'SkinWalker'):
			skin_walker.speed = 6
		else:
			skin_walker.speed = 2.5
			
		if !skin_walker.visible:
			skin_walker.global_position = player.global_position
			if player.rotation.y >= 0:
				skin_walker.global_position.x += 7	
			else:
				skin_walker.global_position.x -= 7	
			
			skin_walker.visible = true
	else:
		interact_ray.target_position.z = -2
		skin_walker.following = false
		skin_walker.visible = false
		skin_walker.speed = 2.5
		
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
		static_body_3d.queue_free()


func _on_signal_area_body_entered(body):
	get_node("SignalArea").queue_free()
	animation_player.play("newNotification")
	
	no_signal_bob.hide()
	no_signal_2_bob.hide()
	
	notification_sound.play()
	no_signal.hide()
	space_16.hide()
	space_18.show()
	sixteenth_message_2.show()
	await get_tree().create_timer(1).timeout
	space_19.show()
	eleventh_message_3.show()
	
	await get_tree().create_timer(2).timeout
	dialogue_text.timeBetweenText = 3
	dialogue_text.queueDialogue("finalmente consegui sinal")
	dialogue_text.queueDialogue("tenho que voltar pra casa, parece que estou sendo observado")
	dialogue_text.showDialogue()
	
	get_node("FinishTaskArea").monitoring = true


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
	player.look_at(skin_walker.global_position, Vector3.UP)
	player.head.set_rotation_degrees(Vector3(40, 0, 0))
	player.camera.fov = 25.0
	death.appear()


func _on_finish_task_area_body_entered(body):
	quest_control.finishQuest()
	self.queue_free()



func _on_area_3d_body_entered(body):
	dialogue_text.timeBetweenText = 3
	dialogue_text.queueDialogue("preciso falar com minha mãe primeiro")
	dialogue_text.showDialogue()
