extends Node3D

@onready var quest_control = $"../QuestControl"
@onready var dialogue_text = $"../Player/DialogueText"
@onready var interact_text = %InteractText
@onready var diary = $"../../../Diary"
@onready var start_quest_col = $StartQuest/CollisionShape3D
@onready var pen_writing = $PenWriting
@onready var timer_sleep_task = $"../SleepTask/TimerSleepTask"
@onready var sleep_area_col = $"../SleepTask/SleepArea/CollisionShape3D"


var canWrite = false

func _process(delta):
	if is_instance_valid(IsRayCasting.collider) and IsRayCasting.canInteract and (Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("LeftMouseButton")) and canWrite:
		SceneTransition.change_scene("", "quickTransition", 0)
		await get_tree().create_timer(1).timeout
		pen_writing.play()
		await get_tree().create_timer(1.5).timeout
		if quest_control.questActive == 9:
			diary.add_page(2)
			diary.toggle_collision_mask(true)
			dialogue_text.timeBetweenText = 3
			dialogue_text.queueDialogue("acho que agora tô entendendo melhor, mas ainda tá estranho")
			dialogue_text.queueDialogue("eu tenho que dar um jeito de falar com alguém amanhã")
			dialogue_text.queueDialogue("mas agora preciso voltar pra cama")
			dialogue_text.showDialogue()
			sleep_area_col.set_deferred("disabled", false)
			self.queue_free()
		else:
			diary.toggle_collision_mask(true)
			quest_control.finishQuest()
			start_quest_col.set_deferred("disabled", true)

func _on_trigger_task_body_entered(body):
	if quest_control.questActive == 5:
		quest_control.startQuest()
		start_quest_col.set_deferred("disabled", false)
		dialogue_text.timeBetweenText = 3
		dialogue_text.queueDialogue("melhor escrever no diário logo antes de começar meu dia")
		dialogue_text.showDialogue()
		get_node("TriggerTask").queue_free()


func _on_start_quest_body_entered(body):
	canWrite = true
	interact_text.text = "[E] Escrever"
	interact_text.show()


func _on_start_quest_body_exited(body):
	canWrite = false
	interact_text.hide()
