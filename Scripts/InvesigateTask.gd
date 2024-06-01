extends Node3D

@onready var quest_control = $"../QuestControl"
@onready var dialogue_text = $"../Player/DialogueText"
@onready var livingroomDoor = $"../House/FrontDoor"
@onready var house = $"../House"
@onready var interact_text = %InteractText
@onready var sleep_area_col = $SleepArea/CollisionShape3D
@onready var world_environment = $"../WorldEnvironment".environment

@onready var front_door = $"../House/FrontDoor"
@onready var bedroom_curtain = $"../House/Bedroom1/Curtain"
@onready var bedroom_door = $"../House/Bedroom1/Bedroom1Door"


var canPowerOn = false
var canSleep = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var res = []
	findByClass(house, "OmniLight3D", res)
	for i in res:
		i.hide()
	livingroomDoor.animation.play("OpenDoorAni")
	livingroomDoor.setdoorOpen(true)
	quest_control.startQuest()
	dialogue_text.timeBetweenText = 3
	dialogue_text.queueDialogue("que barulho foi esse?")
	dialogue_text.queueDialogue("e por que as luzes estão apagadas?")
	dialogue_text.queueDialogue("não acredito nisso")
	dialogue_text.showDialogue()



func findByClass(node: Node, className : String, result : Array):
	if node.is_class(className):
		if node.name != "MicrowaveLight":
			result.push_back(node)
		
	for child in node.get_children():
		findByClass(child, className, result)
	
func _physics_process(delta):
	if (Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("LeftMouseButton")) and canSleep and IsRayCasting.canInteract:
		if front_door.doorOpen:
			dialogue_text.queueDialogue("não posso dormir com a porta da frente aberta")
			dialogue_text.timeBetweenText = 3
			dialogue_text.showDialogue()
		elif bedroom_door.doorOpen or bedroom_curtain.CurtainOpened:
			dialogue_text.queueDialogue("preciso fechar a porta e as cortinas antes de dormir")
			dialogue_text.showDialogue()
		else:
			get_node("SleepArea").queue_free()
			SceneTransition.change_scene("", "night2-day2", 0)
			await get_tree().create_timer(1.1).timeout
			world_environment.background_energy_multiplier = 5.0
			world_environment.volumetric_fog_enabled = false
			
		# MUDAR HDRI?
		
		
	if (Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("LeftMouseButton")) and canPowerOn and IsRayCasting.canInteract:
		canPowerOn = false
		get_node("GeneratorArea").queue_free()
		interact_text.hide()
	
		var res = []
		findByClass(house, "OmniLight3D", res)
		
		for i in res:
			i.show()
		await get_tree().create_timer(0.6).timeout
		
		for i in res:
			i.hide()
		await get_tree().create_timer(0.3).timeout
		
		for i in res:
			i.show()
		await get_tree().create_timer(0.3).timeout	
		
		dialogue_text.queueDialogue("gerador velho fica desligando sozinho")
		dialogue_text.showDialogue()
		
		for i in res:
			i.hide()
		await get_tree().create_timer(0.2).timeout
		
		for i in res:
			i.show()
			
		quest_control.finishQuest()
		sleep_area_col.set_deferred("disabled", false)

func _on_generator_area_body_entered(body):
	interact_text.text = "[E] Ligar"
	interact_text.show()
	canPowerOn = true

func _on_generator_area_body_exited(body):
	canPowerOn = false
	interact_text.hide()


func _on_sleep_area_body_entered(body):
	interact_text.text = "[E] Dormir"
	interact_text.show()
	canSleep = true


func _on_sleep_area_body_exited(body):
	canSleep = false
	interact_text.hide()
