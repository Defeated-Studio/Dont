extends Node3D
@onready var player = %Player
@onready var dialogue_text = %Player/DialogueText

@onready var quest_control = $"../QuestControl"
@onready var interact_text = %InteractText

@onready var geladeira_area = $GeladeiraArea
@onready var plate_area = $PlateArea
@onready var forno_area = $FornoArea

@onready var pizza_box = $"../Player/PizzaBox"
@onready var pizza = $Pizza
@onready var metal_plate = $"../House/Kitchen/MetalPlate"

@onready var oven_timer = $OvenTimer
@onready var oven_sound = $OvenSound

var canPickUpPizzaBox = false
var PizzaBox = false

var canPutPizzaOnPlate = false
var PizzaAndPlate = false

var canPutPizzaOnOven = false
var PizzaReady = false
var canPickUpPizza = false

func _ready():
	geladeira_area.monitoring = false
	
func _on_oven_timer_timeout():
	oven_sound.play()
	oven_timer.stop()
	PizzaReady = true
	dialogue_text.queueDialogue("ficou pronto")
	dialogue_text.timeBetweenText = 2
	dialogue_text.showDialogue()
	
func _physics_process(delta):
	if (Input.is_action_just_pressed("interact") and canPickUpPizzaBox):
		canPickUpPizzaBox = false
		PizzaBox = true
		pizza_box.show()
		geladeira_area.queue_free()
		interact_text.hide()
		
		dialogue_text.queueDialogue("beleza, melhor do que aquele lixo que comi ontem")
		dialogue_text.queueDialogue("preciso colocar em um prato de metal")
		dialogue_text.timeBetweenText = 3
		dialogue_text.showDialogue()
		
	if (Input.is_action_just_pressed("interact") and canPutPizzaOnPlate): 
		canPutPizzaOnPlate = false
		PizzaAndPlate = true
		pizza_box.hide()
		pizza.show()
		plate_area.queue_free()
		interact_text.hide()
		
		metal_plate.reparent(player)
		pizza.reparent(player)
		
		dialogue_text.queueDialogue("só colocar no forno agora")
		dialogue_text.timeBetweenText = 3
		dialogue_text.showDialogue()
		
	if (Input.is_action_just_pressed("interact") and canPutPizzaOnOven): 
		canPutPizzaOnOven = false
		PizzaAndPlate = false
		metal_plate.hide()
		pizza.hide()
		interact_text.hide()
		
		oven_timer.start()
		
		dialogue_text.queueDialogue("esperar né")
		dialogue_text.timeBetweenText = 2
		dialogue_text.showDialogue()
		
	if (Input.is_action_just_pressed("interact") and canPickUpPizza): 
		canPickUpPizza = false
		
		metal_plate.show()
		pizza.show()
		forno_area.queue_free()
		
		dialogue_text.queueDialogue("vim muito nessa aqui")
		dialogue_text.timeBetweenText = 2
		dialogue_text.showDialogue()
		
func _on_quest_control_quest_started():
	if quest_control.questActive == 7:
		geladeira_area.monitoring = true
		
		dialogue_text.queueDialogue("to morrendo de fome, mal comi desde que cheguei aqui")
		dialogue_text.queueDialogue("vou catar algo na geladeira")
		dialogue_text.timeBetweenText = 3
		dialogue_text.showDialogue()
		
		quest_control.startQuest()
		
func _on_geladeira_area_body_entered(body):
	interact_text.text = "[E] Pegar Algo"
	interact_text.show()
	canPickUpPizzaBox = true

func _on_geladeira_area_body_exited(body):
	interact_text.hide()
	canPickUpPizzaBox = false

func _on_plate_area_body_entered(body):
	if PizzaBox:
		interact_text.text = "[E] Colocar"
		interact_text.show()
		canPutPizzaOnPlate = true

func _on_plate_area_body_exited(body):
	interact_text.hide()
	canPutPizzaOnPlate = false

func _on_forno_area_body_entered(body):
	if PizzaAndPlate:
		interact_text.text = "[E] Colocar"
		interact_text.show()
		canPutPizzaOnOven = true
		
	if PizzaReady:
		interact_text.text = "[E] Pegar"
		interact_text.show()
		canPickUpPizza = true
		
func _on_forno_area_body_exited(body):
	interact_text.hide()
	canPutPizzaOnOven = false
