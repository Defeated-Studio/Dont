extends Node3D

@onready var interact_text = %InteractText
@onready var quest_control = $"../QuestControl"
@onready var dialogue_text = $"../Player/DialogueText"
@onready var couch_1 = %House/LivingRoom/Couch1
@onready var knifes = %House/Kitchen/Kitchen2/Knifes
@onready var player = %Player
@onready var move_sofa_a = $MoveSofa
@onready var bedroom_1_door = %House/Bedroom1/Bedroom1Door
@onready var rain = $"../../../rain"
@onready var front_door = %House/FrontDoor

@onready var states = $"../../../States"

var canMoveSofa = false
var canGetKnife = false
var readyinRoom = false
var toDo = 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("interact") and canMoveSofa):
		if front_door.getState():
			front_door.setState(false)
		front_door.setDoorMonitoring(false)
		player.change_input_flags(false)
		get_node("SofaArea").queue_free()
		SceneTransition.change_scene("", "quickTransition", 0)
		await get_tree().create_timer(1).timeout
		move_sofa()
		move_sofa_a.play()
		player.change_input_flags(true)
		dialogue_text.queueDialogue("isso deve ajudar")
		dialogue_text.timeBetweenText = 2
		dialogue_text.showDialogue()
		toDo -= 1

	if (Input.is_action_just_pressed("interact") and canGetKnife):
		canGetKnife = false
		knifes.hide()
		get_node("KnifeArea").queue_free()
		toDo -= 1

	if toDo == 0:
		dialogue_text.queueDialogue("preciso ir pro quarto")
		dialogue_text.timeBetweenText = 3
		dialogue_text.showDialogue()
		toDo = -1
	
	if readyinRoom:
		readyinRoom = false
		if bedroom_1_door.getState():
			dialogue_text.queueDialogue("é melhor fechar a porta")
			dialogue_text.timeBetweenText = 3
			dialogue_text.showDialogue()
		else:
			await get_tree().create_timer(2).timeout
			quest_control.finishQuest()
			states.saveStates()
			states.savePapersTaken()
			SceneTransition.change_scene("res://Scenes/Night5.tscn", "dissolve_night4-5")
			var tween = get_tree().create_tween()
			tween.tween_property(rain, "volume_db", -80, 5)

func move_sofa():
	couch_1.position = Vector3(-0.116, 0.738, 3.188)
	couch_1.rotation_degrees = Vector3(0, 89.2, 0)

func _on_room_area_body_entered(body):
	if toDo == -1 and quest_control.questActive == 17:
		readyinRoom = true

func _on_room_area_body_exited(body):
	readyinRoom = false

func _on_sofa_area_body_entered(body):
	if quest_control.questActive == 17:
		canMoveSofa = true
		interact_text.text = "[E] Mover Sofa"
		interact_text.show()

func _on_sofa_area_body_exited(body):
	if quest_control.questActive == 17:
		interact_text.hide()
		canMoveSofa = false

func _on_knife_area_body_entered(body):
	if quest_control.questActive == 17:
		canGetKnife = true
		interact_text.text = "[E] Pegar Faca"
		interact_text.show()

func _on_knife_area_body_exited(body):
	if quest_control.questActive == 17:
		canGetKnife = false
		interact_text.hide()



