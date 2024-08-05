extends Node3D

@onready var quest_control = $"../QuestControl"
@onready var interact_text = %InteractText
@onready var dialogue_text = $"../Player/DialogueText"

@onready var livingroomDoor = %House/FrontDoor
@onready var house = %House
@onready var front_door = %House/FrontDoor
@onready var bedroom_curtain = %House/Bedroom1/Curtain
@onready var bedroom_door = %House/Bedroom1/Bedroom1Door
@onready var sleep_area_col = $SleepArea/CollisionShape3D
@onready var start_quest_col = $"../WriteDiaryTask/StartQuest/CollisionShape3D"
@onready var diary = %Diary

@onready var player = %Player
@onready var world = $".."

@onready var states = $"../../../States"

@onready var timer_write_diary = $TimerWriteDiary

var canSleep = false
var canGetUp = false
var questFlag = 0
var prevPosition
var prevRotation


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
				await get_tree().create_timer(1).timeout
				canSleep = false
				sleep_area_col.set_deferred("disabled", true)
				teleport_player()
				on_bed_dialogue()
				player.change_input_flags(false)
				world.canOpenMobile = false
				timer_write_diary.start()
			else:
				quest_control.finishQuest()
				states.saveStates()
				states.savePapersTaken()
				SceneTransition.change_scene("res://Scenes/Night3.tscn", "dissolve_night2-3")
				self.queue_free()
				
	if (Input.is_action_just_pressed("interact") and canGetUp):
		canGetUp = false
		interact_text.hide()
		diary.toggle_collision_mask(false)
		SceneTransition.change_scene("", "quickTransition", 0)
		await get_tree().create_timer(1).timeout
		player.global_position = prevPosition
		player.set_rotation_degrees(prevRotation)
		player.change_input_flags(true)
		world.canOpenMobile = true

func teleport_player():
	prevPosition = player.global_position
	prevRotation = player.get_rotation_degrees()
	player.global_position = Vector3(6.383, 4.8, -0.281)
	player.set_rotation_degrees(Vector3(90, 90, 0))
	
func on_bed_dialogue():
	await get_tree().create_timer(2.5).timeout
	dialogue_text.timeBetweenText = 3
	dialogue_text.queueDialogue("não tô conseguindo dormir, aquilo que eu vi ta me assombrando")
	dialogue_text.queueDialogue("não pode ser real, eu to imaginando coisa")
	dialogue_text.queueDialogue("vou tentar arrumar meus pensamentos escrevendo eles")
	dialogue_text.showDialogue()

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
	
func _on_timer_write_diary_timeout():
	if quest_control.questActive == 9:
		start_quest_col.set_deferred("disabled", false)
		canGetUp = true
		interact_text.show()
		interact_text.text = "[E] Levantar"
