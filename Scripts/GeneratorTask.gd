extends Node3D

@onready var quest_control = $"../QuestControl"
@onready var interact_text = %InteractText
@onready var player_dialogue = $"../Player/DialogueText"
@onready var tutorial_text = %TutorialText
@onready var front_door = %House/FrontDoor
@onready var house = %House

var canPowerOn = false
var canTriggerTask = true
var toDo = 2

func _process(delta):
	if toDo == 0:
		quest_control.finishQuest()
		interact_text.text = ""
		toDo = -1
		
	if Input.is_action_just_pressed("Mobile") and tutorial_text.text == "[M] Abrir Celular":
		tutorial_text.hide()
		
	if (is_instance_valid(IsRayCasting.collider)) and (IsRayCasting.collider.name == "Door") and (Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("LeftMouseButton")) and canTriggerTask:
		canTriggerTask = false
		await get_tree().create_timer(0.8).timeout
		triggerTask()
	
func findByClass(node: Node, className : String, result : Array):
	if node.is_class(className):
		if node.name != "MicrowaveLight":
			result.push_back(node)
		
	for child in node.get_children():
		findByClass(child, className, result)
	
func _physics_process(delta):
	if (is_instance_valid(IsRayCasting.collider)) and (IsRayCasting.collider.name == "Key"):
		interact_text.show()
		interact_text.text = "[E] Pegar Chave"
	elif interact_text.text == "[E] Pegar Chave":
		interact_text.hide()
		pass
		
	if (is_instance_valid(IsRayCasting.collider)) and (IsRayCasting.collider.name == "Key") and (Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("LeftMouseButton")):
		front_door.locked = false
		toDo -= 1
		get_node("Key").queue_free()
		
	if (is_instance_valid(IsRayCasting.collider)) and (IsRayCasting.collider.name == "Generator") and (IsRayCasting.canInteract) and (Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("LeftMouseButton")) and canPowerOn:
		canPowerOn = false
		get_node("GeneratorArea").queue_free()
		interact_text.hide()
		toDo -= 1
	
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
		
		for i in res:
			i.hide()
		await get_tree().create_timer(0.2).timeout
		
		for i in res:
			i.show()
	

func _on_generator_area_body_entered(body):
	if quest_control.questActive == 0:
		canPowerOn = true
		interact_text.show()
		interact_text.text = "[E] Ligar"

func _on_generator_area_body_exited(body):
	canPowerOn = false
	interact_text.hide()

func showInteractText():
	tutorial_text.text = "[M] Abrir Celular"
	tutorial_text.show()
	
func triggerTask():
	player_dialogue.timeBetweenText = 2
	player_dialogue.queueDialogue("eu lembro do Bob falar algo da chave")
	player_dialogue.queueDialogue("tenho que ver meu celular")
	player_dialogue.showDialogue()
	await get_tree().create_timer(4).timeout
	showInteractText()
	quest_control.startQuest()


func _on_turn_on_gen_body_entered(body):
	if quest_control.questActive == 0:
		player_dialogue.timeBetweenText = 3
		player_dialogue.queueDialogue("preciso ligar o gerador")
		player_dialogue.showDialogue()
