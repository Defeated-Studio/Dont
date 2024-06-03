extends Node3D


var canSleep = false
@onready var interact_text = %InteractText
@onready var quest_control = $"../QuestControl"
@onready var dialogue_text = $"../Player/DialogueText"

@onready var front_door = $"../House/FrontDoor"
@onready var bedroom_curtain = $"../House/Bedroom1/Curtain"
@onready var bedroom_door = $"../House/Bedroom1/Bedroom1Door"
@onready var states = $"../../../States"

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
		else:
			quest_control.finishQuest()
			states.saveStates()
			SceneTransition.change_scene("res://Scenes/Night2.tscn", "night1-2")

func _on_bed_area_body_entered(body):
	if quest_control.questActive == 1:
		canSleep = true
		interact_text.show()
		interact_text.text = "[E] Dormir"

func _on_bed_area_body_exited(body):
	canSleep = false
	interact_text.hide()


func _on_trigger_sleep_task_body_entered(body):
	if quest_control.questActive == 1:
		quest_control.startQuest()
		dialogue_text.timeBetweenText = 3
		dialogue_text.queueDialogue("preciso ir deitar, não estou me sentindo muito bem")
		dialogue_text.showDialogue()
		get_node("TriggerSleepTask").queue_free()
