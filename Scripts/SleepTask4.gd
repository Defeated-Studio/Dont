extends Node3D


var canSleep = false
@onready var interact_text = %InteractText
@onready var quest_control = $"../QuestControl"
@onready var dialogue_text = $"../Player/DialogueText"
@onready var rain = $"../../../rain"

@onready var front_door = %House/FrontDoor
@onready var bedroom_curtain = %House/Bedroom1/Curtain
@onready var bedroom_door = %House/Bedroom1/Bedroom1Door
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
			states.savePapersTaken()
			SceneTransition.change_scene("res://Scenes/Night5.tscn", "dissolve_night4-5")
			var tween = get_tree().create_tween()
			tween.tween_property(rain, "volume_db", -80, 5)

func _on_bed_area_body_entered(body):
	if quest_control.questActive == 14:
		canSleep = true
		interact_text.show()
		interact_text.text = "[E] Dormir"

func _on_bed_area_body_exited(body):
	if body.name != "Mom":
		canSleep = false
		interact_text.hide()
