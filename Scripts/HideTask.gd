extends Node3D

@onready var door_break_open = $doorBreakOpen
@onready var paper = $Paper

@onready var dialogue_text = %Player/DialogueText
@onready var front_door = %House/FrontDoor
@onready var mom = $Mom
@onready var quest_control = $"../QuestControl"
@onready var interact_text = %InteractText
@onready var position_target = $position
@onready var player = %Player
@onready var hiding_camera = $HidingCamera
@onready var microfone = $"../../../Microfone"

var canHideWrongSpot = false
var canHideRightSpot = false
var hiding = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if canHideWrongSpot and Input.is_action_just_pressed("interact"):
		dialogue_text.timeBetweenText = 3.5
		dialogue_text.queueDialogue("não consigo me esconder aqui, preciso achar outro lugar")
		dialogue_text.showDialogue()
		
	if canHideRightSpot and !hiding and Input.is_action_just_pressed("interact"):
		hideSpot()
		hiding = true
	
	elif hiding and (Input.is_action_just_pressed("interact")):
		exitSpot()
		hiding = false

func exitSpot():
	SceneTransition.change_scene("", "quickTransition", 0)
	player.change_input_flags(true)
	await get_tree().create_timer(1).timeout
	hiding_camera.set_current(false)
	interact_text.hide()
	microfone.hide()

func hideSpot():
	SceneTransition.change_scene("", "quickTransition", 0)
	player.change_input_flags(false)
	await get_tree().create_timer(1).timeout
	player.global_position = position_target.get_global_transform().origin
	player.set_rotation_degrees(Vector3(0, 90, 0))
	hiding_camera.set_current(true)
	interact_text.text = "[E] Sair"
	interact_text.show()
	microfone.show()

func _on_paper_close():
	quest_control.finishQuest()
	quest_control.startQuest()
	mom.show()
	door_break_open.play()
	await get_tree().create_timer(0.5).timeout
	dialogue_text.timeBetweenText = 2.5
	dialogue_text.queueDialogue("O QUE FOI ISSO?")
	dialogue_text.showDialogue()
	front_door.setState(true)
	



func _on_wrong_spot_body_entered(body):
	if quest_control.questActive == 15:
		interact_text.text = "[E] Esconder"
		interact_text.show()
		canHideWrongSpot = true


func _on_wrong_spot_body_exited(body):
	if quest_control.questActive == 15:
		interact_text.hide()
		canHideWrongSpot = false


func _on_right_spot_body_entered(body):
	if quest_control.questActive == 15:
		interact_text.text = "[E] Esconder"
		interact_text.show()
		canHideRightSpot = true


func _on_right_spot_body_exited(body):
	if quest_control.questActive == 15:
		interact_text.hide()
		canHideRightSpot = false
