extends Node3D

@onready var quest_control = $"../QuestControl"
@onready var dialogue_text = $"../Player/DialogueText"
@onready var interact_text = %InteractText
@onready var diary = $"../../../Diary"
@onready var start_quest_col = $StartQuest/CollisionShape3D
@onready var pen_writing = $PenWriting


var canWrite = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if is_instance_valid(IsRayCasting.collider) and IsRayCasting.canInteract and (Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("LeftMouseButton")) and canWrite:
		SceneTransition.change_scene("", "quickTransition", 0)
		await get_tree().create_timer(1).timeout
		pen_writing.play()
		diary.toggle_visibility()
		await get_tree().create_timer(1.5).timeout
		quest_control.finishQuest()
		self.queue_free()

func _on_trigger_task_body_entered(body):
	if quest_control.questActive == 5:
		quest_control.startQuest()
		start_quest_col.set_deferred("disabled", false)
		dialogue_text.timeBetweenText = 3
		dialogue_text.queueDialogue("nao quero pensar agora fazer isso é mt dificil como pode")
		dialogue_text.showDialogue()
		get_node("TriggerTask").queue_free()
		


func _on_start_quest_body_entered(body):
	canWrite = true
	interact_text.text = "[E] Escrever"
	interact_text.show()


func _on_start_quest_body_exited(body):
	canWrite = false
	interact_text.hide()

