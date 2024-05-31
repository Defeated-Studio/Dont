extends Node3D

@onready var quest_control = $"../QuestControl"
@onready var house = $"../House"
@onready var interact_text = %InteractText
@onready var player_dialogue = $"../Player/DialogueText"
@onready var tutorial_text = %TutorialText
@onready var front_door = $"../House/FrontDoor"

var canPowerOn = false

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
	if (IsRayCasting.collider) and (IsRayCasting.collider.name == "Key") and (Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("LeftMouseButton")):
		get_node("Key").queue_free()
		front_door.locked = false
		
	if (IsRayCasting.canInteract) and (IsRayCasting.collider) and (IsRayCasting.collider.name == "Generator") and (Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("LeftMouseButton")) and canPowerOn:
		canPowerOn = false
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
		
		for i in res:
			i.hide()
		await get_tree().create_timer(0.2).timeout
		
		for i in res:
			i.show()
			
		quest_control.finishQuest()
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
	player_dialogue.queueDialogue("Eu lembro do Bob falar algo da chave")
	player_dialogue.queueDialogue("tenho que ver meu celular")
	player_dialogue.showDialogue()
	await get_tree().create_timer(5).timeout
	showInteractText()
	quest_control.startQuest()
	
