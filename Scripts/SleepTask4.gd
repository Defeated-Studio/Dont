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
		get_node("BedArea").queue_free()
		dialogue_text.queueDialogue("não consigo dormir depois disso")
		dialogue_text.queueDialogue("preciso achar algum jeito de me proteger")
		dialogue_text.timeBetweenText = 3
		dialogue_text.showDialogue()
		quest_control.finishQuest()
		quest_control.startQuest()

func _on_bed_area_body_entered(body):
	if quest_control.questActive == 16:
		canSleep = true
		interact_text.show()
		interact_text.text = "[E] Dormir"

func _on_bed_area_body_exited(body):
	if body.name != "Mom":
		canSleep = false
		interact_text.hide()
