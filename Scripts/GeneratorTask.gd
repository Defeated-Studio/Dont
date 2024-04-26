extends Node3D

@onready var quest_control = $"../QuestControl"
@onready var interact_text = $"../InteractText/InteractText"
@onready var house = $"../House"

var canPowerOn = false

func _ready():
	if quest_control.questActive == 0:
		var res = []
		findByClass(house, "OmniLight3D", res)
		for i in res:
			i.hide()
		
func findByClass(node: Node, className : String, result : Array):
	if node.is_class(className):
		result.push_back(node)
		
	for child in node.get_children():
		findByClass(child, className, result)
	
func _physics_process(delta):
	if Input.is_action_just_pressed("interact") and canPowerOn:
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
	if quest_control.questActive == 0:
		canPowerOn = true
		interact_text.show()
		interact_text.text = "[E] Power On"

func _on_generator_area_body_exited(body):
	canPowerOn = false
	interact_text.hide()
