extends Node3D

@onready var front_door = %House/FrontDoor
@onready var mom = $Mom
@onready var door_knock = $"../SleepTask3/DoorKnock"
@onready var peep_hole_text = $PeepHoleText
@onready var fisheye = $"../../../Fisheye"
@onready var world = %World
@onready var dialogue_text = $DialogueText
@onready var quest_control = $"../QuestControl"

## TODO DIALOGO ENTRE A MÃE E ELE NA PORTA
## LISTA COM DIALOGOS 


var audioCanPlay = false
var canPeepHole = false
var hasSeenPeepHole = false
var inPeepHole = false

func _process(delta):
	if audioCanPlay:
		if !door_knock.playing:
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
		await get_tree().create_timer(1).timeout
		peep_hole_text.text = "[Q] Questionar"
		
	elif inPeepHole and !hasSeenPeepHole and Input.is_action_just_pressed("PeepHole"):
		world.hidePeepHole()
		inPeepHole = false
		
	if Input.is_action_just_pressed("interact") and inPeepHole:
		pass
	
	if hasSeenPeepHole and Input.is_action_just_pressed("PeepHole"):
		peep_hole_text.hide()
		dialogue_text.text = "Mãe???"

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
	
