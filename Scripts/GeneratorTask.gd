extends Node3D

@onready var quest_control = $"../QuestControl"
@onready var house = $"../House"
@onready var interact_text = %InteractText
@onready var player_dialogue = $"../Player/DialogueText"
@onready var tutorial_text = %TutorialText
@onready var front_door = $"../House/FrontDoor"

var canPowerOn = false
var toDo = 2

func _process(delta):
	if Input.is_action_just_pressed("Mobile"):
		tutorial_text.hide()
		
func _ready():
	pass
	
func findByClass(node: Node, className : String, result : Array):
	if node.is_class(className):
		if node.name != "MicrowaveLight":
			result.push_back(node)
		
	for child in node.get_children():
		findByClass(child, className, result)
	
func _physics_process(delta):
	if (IsRayCasting.collider) and (IsRayCasting.collider.name == "Key"):
		interact_text.show()
		interact_text.text = "[E] Pegar"
	elif interact_text.text == "[E] Pegar":
		interact_text.hide()
		
	if (IsRayCasting.collider) and (IsRayCasting.collider.name == "Key") and (Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("LeftMouseButton")):
		front_door.locked = false
		toDo -= 1
		get_node("Key").queue_free()
		if toDo == 0:
			quest_control.finishQuest()
			interact_text.text = ""
			self.queue_free()
		
	if (IsRayCasting.collider) and (IsRayCasting.collider.name == "Generator") and (IsRayCasting.canInteract) and (Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("LeftMouseButton")) and canPowerOn:
		canPowerOn = false
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
		
		if toDo == 0:
			quest_control.finishQuest()
			interact_text.text = ""
			self.queue_free()
	

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
	
func _on_trigger_task_body_entered(body):
	get_node("TriggerTask").queue_free()
	player_dialogue.timeBetweenText = 2.5
	player_dialogue.queueDialogue("eu lembro do Bob falar algo da chave")
	player_dialogue.queueDialogue("tenho que ver meu celular")
	player_dialogue.showDialogue()
	await get_tree().create_timer(5).timeout
	showInteractText()
	quest_control.startQuest()
