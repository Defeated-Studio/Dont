extends Node3D

@onready var quest_control = $"../QuestControl"
@onready var dialogue_text = $"../Player/DialogueText"
@onready var livingroomDoor = $"../House/FrontDoor"
@onready var house = $"../House"
@onready var interact_text = %InteractText

var canPowerOn = false


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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func findByClass(node: Node, className : String, result : Array):
	if node.is_class(className):
		if node.name != "MicrowaveLight":
			result.push_back(node)
		
	for child in node.get_children():
		findByClass(child, className, result)
	
func _physics_process(delta):
	if (Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("LeftMouseButton")) and canPowerOn:
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


func _on_generator_area_body_entered(body):
	interact_text.text = "[E] Ligar"
	interact_text.show()
	canPowerOn = true

func _on_generator_area_body_exited(body):
	canPowerOn = false
	interact_text.hide()
