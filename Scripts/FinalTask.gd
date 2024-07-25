extends Node3D

@onready var door_knock = $DoorKnock
@onready var dialogue_text = %Player/DialogueText
@onready var world_environment = $"../WorldEnvironment".environment
@onready var world = $".."
@onready var timer = $Timer
@onready var player = %Player

@onready var peep_hole_text = $PeepHoleText
@onready var couch_1 = %House/LivingRoom/Couch1
@onready var move_sofa = $MoveSofa

var audioCanPlay = false
var canPeepHole = false
var inPeepHole = false
var hasSeenPeepHole = false
var canMoveSofa = false

func _ready():
	door_knock.play()
	
	world_environment.background_energy_multiplier = 0.7
	dialogue_text.timeBetweenText = 3
	dialogue_text.queueDialogue("finalmente, só pode ser minha mãe")
	dialogue_text.showDialogue()


func _process(delta):
	if audioCanPlay:
		if !door_knock.playing:
			await get_tree().create_timer(0.5).timeout
			door_knock.play()
	
	if canPeepHole and !hasSeenPeepHole and Input.is_action_just_pressed("PeepHole") and !inPeepHole:
		audioCanPlay = false
		door_knock.stop()
		world.showPeepHole()
		inPeepHole = true
		hasSeenPeepHole = true
		
	elif inPeepHole and hasSeenPeepHole:
		timer.start()
		inPeepHole = false
		
	elif (Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("LeftMouseButton") or Input.is_action_just_pressed("PeepHole")) and inPeepHole:
		pass
	
	if hasSeenPeepHole and canMoveSofa and Input.is_action_just_pressed("PeepHole"):
		player.change_input_flags(false)
		get_node("InteractArea").queue_free()
		SceneTransition.change_scene("", "quickTransition", 0)
		await get_tree().create_timer(1).timeout
		couch_1.position = Vector3(-0.816, 0.738, 2.588)
		couch_1.rotation_degrees = Vector3(0, 60, 0)
		move_sofa.play()
		player.change_input_flags(true)
		peep_hole_text.hide()

func _on_interact_area_body_entered(body):
	if !hasSeenPeepHole:
		peep_hole_text.text = "[Q] Olhar olho mágico"
		peep_hole_text.show()
		canPeepHole = true

func _on_interact_area_body_exited(body):
	peep_hole_text.hide()
	canPeepHole = false

func _on_timer_timeout():
	world.hidePeepHole()
	peep_hole_text.text = "[Q] Mover Sofá"
	peep_hole_text.show()
	canMoveSofa = true
