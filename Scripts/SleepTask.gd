extends Node3D
var canSleep = false
@onready var interact_text = %InteractText
@onready var quest_control = $"../QuestControl"
@onready var dialogue_text = $"../Player/DialogueText"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("LeftMouseButton")) and canSleep and IsRayCasting.canInteract:
		quest_control.finishQuest()
		SceneTransition.change_scene("res://Scenes/Night2.tscn")

func _on_bed_area_body_entered(body):
	if quest_control.questActive == 4:
		canSleep = true
		interact_text.show()
		interact_text.text = "[E] Dormir"

func _on_bed_area_body_exited(body):
	canSleep = false
	interact_text.hide()


func _on_trigger_sleep_task_body_entered(body):
	if quest_control.questActive == 4:
		quest_control.startQuest()
		dialogue_text.timeBetweenText = 3
		dialogue_text.queueDialogue("preciso ir deitar, não estou me sentindo muito bem")
		dialogue_text.showDialogue()
		get_node("TriggerSleepTask").queue_free()
