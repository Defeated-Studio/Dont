extends Node3D

@onready var quest_control = $"../QuestControl"
@onready var interact_text = %InteractText
@onready var dialogue_text = $"../Player/DialogueText"

@onready var livingroomDoor = $"../House/FrontDoor"
@onready var house = $"../House"
@onready var front_door = $"../House/FrontDoor"
@onready var bedroom_curtain = $"../House/Bedroom1/Curtain"
@onready var bedroom_door = $"../House/Bedroom1/Bedroom1Door"
@onready var sleep_area_col = $SleepArea/CollisionShape3D

@onready var player = %Player

@onready var timer_write_diary = $"../WriteDiaryTask/TimerWriteDiary"

var canSleep = false
var questFlag = 0


func _process(delta):
	if (Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("LeftMouseButton")) and canSleep and IsRayCasting.canInteract and quest_control.questActive == 9:
		if front_door.doorOpen:
			dialogue_text.queueDialogue("não posso dormir com a porta da frente aberta")
			dialogue_text.timeBetweenText = 3
			dialogue_text.showDialogue()
		elif bedroom_door.doorOpen or bedroom_curtain.CurtainOpened:
			dialogue_text.queueDialogue("preciso fechar a porta e as cortinas antes de dormir")
			dialogue_text.showDialogue()
		else:
			if questFlag == 0:
				questFlag += 1
				SceneTransition.change_scene("", "quickTransition", 0)
				canSleep = false
				player.set_rotation_degrees(Vector3(0, 120, 0))
				sleep_area_col.set_deferred("disabled", true)
				timer_write_diary.start()
			else:
				quest_control.finishQuest()
				self.queue_free()


func _on_sleep_area_body_entered(body):
	if quest_control.questActive == 9:
		interact_text.text = "[E] Dormir"
		interact_text.show()
		canSleep = true


func _on_sleep_area_body_exited(body):
	canSleep = false
	interact_text.hide()


func _on_timer_sleep_task_timeout():
	quest_control.startQuest()
	
	dialogue_text.timeBetweenText = 3
	dialogue_text.queueDialogue("esse lugar ta acabando comigo")
	dialogue_text.queueDialogue("acho que tô vendo coisas")
	dialogue_text.queueDialogue("melhor eu tentar dormir pra me acalmar")
	dialogue_text.showDialogue()
