extends Node3D


var canSleep = false
@onready var interact_text = %InteractText
@onready var quest_control = $"../QuestControl"
@onready var dialogue_text = $"../Player/DialogueText"

@onready var front_door = %House/FrontDoor
@onready var bedroom_curtain = %House/Bedroom1/Curtain
@onready var bedroom_door = %House/Bedroom1/Bedroom1Door
@onready var states = $"../../../States"
@onready var sleep_col = $BedArea/CollisionShape3D

@onready var door_knock = $DoorKnock
@onready var mom = $"../AnswerDoorTask/Mom"
@onready var mom_anim = $"../AnswerDoorTask/Mom/AnimationPlayer"
@onready var answer_door_task = $"../AnswerDoorTask"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("LeftMouseButton")) and canSleep and IsRayCasting.canInteract:
		if front_door.doorOpen:
			dialogue_text.queueDialogue("não posso dormir com a porta da frente aberta")
			dialogue_text.timeBetweenText = 3
			dialogue_text.showDialogue()
		elif bedroom_door.doorOpen or bedroom_curtain.CurtainOpened:
			dialogue_text.queueDialogue("preciso fechar a porta e as cortinas antes de dormir")
			dialogue_text.showDialogue()
		elif quest_control.questActive == 11:
			quest_control.finishQuest()
			canSleep = false
			SceneTransition.change_scene("", "dissolve_night3to333AM", 0)
			mom.show()
			mom_anim.play("idle")
			await get_tree().create_timer(7).timeout
			answer_door_task.audioCanPlay = true
		else:
			quest_control.finishQuest()
			states.saveStates()
			states.savePapersTaken()
			SceneTransition.change_scene("res://Scenes/Night4.tscn", "dissolve_night333AMToNight4", 1)
			self.queue_free()

func _on_bed_area_body_entered(body):
	if quest_control.questActive == 11 or quest_control.questActive == 13:
		canSleep = true
		interact_text.show()
		interact_text.text = "[E] Dormir"

func _on_bed_area_body_exited(body):
	canSleep = false
	interact_text.hide()


func _on_quest_control_quest_started():
	if quest_control.questActive == 11:
		await get_tree().create_timer(5).timeout
		quest_control.startQuest()
		dialogue_text.timeBetweenText = 4
		dialogue_text.queueDialogue("preciso ir deitar, talvez assim o tempo passe mais rápido e minha mãe chegue logo")
		dialogue_text.showDialogue()
		sleep_col.set_deferred("disabled", false)
