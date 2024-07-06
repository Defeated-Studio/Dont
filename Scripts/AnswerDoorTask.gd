extends Node3D

@onready var front_door = %House/FrontDoor
@onready var mom = $Mom
@onready var door_knock = $"../SleepTask3/DoorKnock"
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
@onready var skin_walker_door = $SkinWalkerDoor
@onready var animation_player = $SkinWalkerDoor/AnimationPlayer

## TODO DIALOGO ENTRE A MÃE E ELE NA PORTA
## LISTA COM DIALOGOS 


var audioCanPlay = false
var canPeepHole = false
var hasSeenPeepHole = false
var inPeepHole = false
var readyToChoose = false

var text_queue = []
var timeBetweenText = 2.5


func _process(delta):
	if audioCanPlay:
		if !door_knock.playing:
			await get_tree().create_timer(0.5).timeout
			door_knock.play()
	if front_door.getState():
		mom.hide()
		audioCanPlay = false
		
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
		
	if readyToChoose and Input.is_action_just_pressed("PeepHole"):
		readyToChoose = false
		dialogue_text.hide()
		player.change_input_flags(true)
		mom.hide()
		await get_tree().create_timer(1.5).timeout
		dialogue_text_player.queueDialogue("o que foi isso???")
		dialogue_text_player.queueDialogue("não era minha mãe, eu tenho certeza")
		dialogue_text_player.queueDialogue("os papeis estavam falando a verdade o tempo todo")
		dialogue_text_player.queueDialogue("é como se ela soubesse o que vai acontecer")
		dialogue_text_player.showDialogue()
		quest_control.finishQuest()
		
		
	if readyToChoose and Input.is_action_just_pressed("interact"):
		readyToChoose = false
		front_door.setStateAnimation(true)
		dialogue_text.hide()
		await get_tree().create_timer(1.5).timeout
		skin_walker_door.show()
		animation_player.play("idle")
		death.appear()

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
	
func setUp():
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(head, "rotation_degrees", Vector3(0, 0, 0), 1)
	tween.tween_property(player, "position", Vector3(player.global_position.x, player.global_position.y, player.global_position.z - 1), 1)
	player.change_input_flags(false)
	
	
func dialogueMomJake():
	queueDialogue("Jake: mãe???")
	queueDialogue("Mãe: sim sou eu filho, abra a porta")
	queueDialogue("Jake: mas você falou que iria demorar, o que aconteceu?")
	queueDialogue("Mãe: eu consegui chegar mais rapido do que imaginei")
	queueDialogue("Mãe: abre a porta filho e vamos embora")
	queueDialogue("[E] Abrir Porta\n[Q] Não Responder")
	showDialogue()

func queueDialogue(text):
	text_queue.push_back(text)

func showDialogue():
	dialogue_text.text = text_queue.pop_front()
	if dialogue_text.text == "[E] Abrir Porta\n[Q] Não Responder":
		dialogue_text.show()
		readyToChoose = true
	else:
		dialogue_text.show()
		dialogue_timer.start(timeBetweenText)

func _on_dialogue_timer_timeout():
	if !text_queue.is_empty():
		showDialogue()
	elif !(dialogue_text.text == "[E] Abrir Porta\n[Q] Não Responder"):
		dialogue_text.hide()
