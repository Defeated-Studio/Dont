extends Node3D

@onready var front_door = %House/FrontDoor
@onready var mom = $Mom
@onready var door_knock = $DoorKnock
@onready var peep_hole_text = $PeepHoleText
@onready var fisheye = $"../../../Fisheye"
@onready var world = %World
@onready var dialogue_text = $DialogueText
@onready var dialogue_text_player = %Player/DialogueText
@onready var quest_control = $"../QuestControl"
@onready var head = %Player/Head
@onready var player = %Player
@onready var dialogue_timer = $dialogue_timer
@onready var death = $"../../../Death"
@onready var skin_walker_door = %SkinWalkerDoor
@onready var animation_player = %SkinWalkerDoor/AnimationPlayer

var audioCanPlay = false
var canPeepHole = false
var hasSeenPeepHole = false
var inPeepHole = false
var readyToChoose = false
var canDie = false

var text_queue = []
var timeBetweenText = 3

func _process(delta):
	if audioCanPlay:
		if !door_knock.playing:
			await get_tree().create_timer(0.5).timeout
			door_knock.play()
	if front_door.getState() and canDie:
		canDie = false
		mom.hide()
		audioCanPlay = false
		door_knock.stop()
		await get_tree().create_timer(2).timeout
		showSkinWalker()

	if canPeepHole and !hasSeenPeepHole and Input.is_action_just_pressed("PeepHole") and !inPeepHole:
		audioCanPlay = false
		door_knock.stop()
		world.showPeepHole()
		inPeepHole = true
		hasSeenPeepHole = true
		
	elif inPeepHole and hasSeenPeepHole and Input.is_action_just_pressed("PeepHole"):
		world.hidePeepHole()
		inPeepHole = false
		peep_hole_text.text = "[Q] Questionar"
		
	elif (Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("LeftMouseButton")) and inPeepHole:
		pass
	
	elif hasSeenPeepHole and Input.is_action_just_pressed("PeepHole"):
		setUp()
		peep_hole_text.hide()
		await get_tree().create_timer(1).timeout
		dialogueMomJake()
		hasSeenPeepHole = false
		get_node("InteractArea").queue_free()
		
	if readyToChoose and Input.is_action_just_pressed("PeepHole"):
		readyToChoose = false
		dialogue_text.hide()
		player.change_input_flags(true)
		mom.hide()
		
		await get_tree().create_timer(1.5).timeout
		door_knock.play()
		await get_tree().create_timer(0.5).timeout
		dialogue_text_player.queueDialogue("será que atendo?")
		dialogue_text_player.showDialogue()
		quest_control.finishQuest()
		quest_control.startQuest()
		await get_tree().create_timer(6.6).timeout
		door_knock.stop()
		
	if readyToChoose and Input.is_action_just_pressed("interact"):
		mom.hide()
		canDie = false
		readyToChoose = false
		front_door.setStateAnimation(true)
		player.change_input_flags(true)
		dialogue_text.hide()
		await get_tree().create_timer(1.5).timeout
		animation_player.play("idle")
		showSkinWalker()

func _on_interact_area_body_entered(body):
	if !hasSeenPeepHole and quest_control.questActive == 12:
		peep_hole_text.text = "[Q] Olhar olho mágico"
		peep_hole_text.show()
		canPeepHole = true
	elif quest_control.questActive == 12:
		peep_hole_text.text = "[Q] Questionar"
		peep_hole_text.show()


func _on_interact_area_body_exited(body):
	peep_hole_text.hide()
	canPeepHole = false
	
func showSkinWalker():
	var tween = get_tree().create_tween()
	skin_walker_door.show()
	tween.tween_property(skin_walker_door, "position", Vector3(0, -0.147, -1), 0.1)
	await get_tree().create_timer(0.1).timeout
	death.appear()
	
func setUp():
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(head, "rotation_degrees", Vector3(0, 0, 0), 1)
	tween.tween_property(player, "position", Vector3(player.global_position.x, player.global_position.y, player.global_position.z - 1), 1)
	player.change_input_flags(false)
	
	
func dialogueMomJake():
	queueDialogue("Jake: mãe???")
	queueDialogue(" ")
	queueDialogue("Mãe: sim, filho. eu vim te buscar, vamos para casa")
	queueDialogue(" ")
	queueDialogue("Jake: mas você disse que ia demorar um pouco até aqui")
	queueDialogue(" ")
	queueDialogue("Mãe: eu... me apressei, consegui chegar mais rápido do que eu achava")
	queueDialogue(" ")
	queueDialogue("Mãe: abre a porta filho e vamos embora")
	queueDialogue(" ")
	queueDialogue("Jake: mas...")
	queueDialogue("[ E ] Abrir Porta\n[ Q ] Não Responder")
	showDialogue()

func queueDialogue(text):
	text_queue.push_back(text)

func showDialogue():
	dialogue_text.text = text_queue.pop_front()
	if dialogue_text.text == "[ E ] Abrir Porta\n[ Q ] Não Responder":
		dialogue_text.show()
		readyToChoose = true
	else:
		dialogue_text.show()
		if dialogue_text.text == " ":
			timeBetweenText = 0.5
		else:
			timeBetweenText = 2.5
		dialogue_timer.start(timeBetweenText)

func _on_dialogue_timer_timeout():
	if !text_queue.is_empty():
		showDialogue()
	elif !(dialogue_text.text == "[ E ] Abrir Porta\n[ Q ] Não Responder"):
		dialogue_text.hide()
