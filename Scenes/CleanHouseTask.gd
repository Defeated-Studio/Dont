extends Node3D

@onready var trigger_clean_house_task = $TriggerCleanHouseTask
@onready var quest_control = $"../QuestControl"
@onready var dialogue_text = $"../DialogueText/DialogueText"
@onready var dialogue_timer = $"../DialogueText/DialogueTimer"
@onready var interact_text = $"../InteractText/InteractText"

@onready var toilet = $"../House/Bathroom2/Toilet"
@onready var clean_sodas = $CleanSodas/CleanSodas
@onready var clean_pizza = $CleanPizza/CleanPizza
@onready var clean_living_room_plates = $CleanLivingRoomPlates/CleanLivingRoomPlates
@onready var clean_kitchen_plates = $CleanKitchenPlates/CleanKitchenPlates
@onready var clean_cereal = $CleanCereal/CleanCereal
@onready var clean_toilet = $CleanToilet/CleanToilet
@onready var trash = $TrashCan/Trash

var questEnabled = false
var canClean = false
var currentNode
var toClean = 6
var canThrowAway = false

func _process(delta):
	if Input.is_action_just_pressed("interact") and canClean:
		if currentNode == "CleanToilet":
			toilet.cleanToilet()
		get_node(currentNode).queue_free()
		toClean -= 1
		if toClean == 0:
			await get_tree().create_timer(1.5).timeout
			showDialogue("I think i'm done, i need to throw it away now")
			trash.set_deferred("disabled", false) 
	
	if Input.is_action_just_pressed("interact") and canThrowAway:
		quest_control.finishQuest()
		get_node("TrashCan").queue_free()
		await get_tree().create_timer(1.0).timeout
		showDialogue("This house doesn't seem right")

func _on_trigger_clean_house_task_body_entered(body):
	if quest_control.questActive == 1:
		showDialogue("This house is a mess, i think i should clean it")
		activateCollisions()
		get_node("TriggerCleanHouseTask").queue_free()
		await get_tree().create_timer(3.0).timeout
		quest_control.startQuest()
	else:
		showDialogue("Maybe i should turn the power back on first")


func activateCollisions():
	clean_sodas.set_deferred("disabled", false)
	clean_pizza.set_deferred("disabled", false)
	clean_living_room_plates.set_deferred("disabled", false)
	clean_kitchen_plates.set_deferred("disabled", false)
	clean_cereal.set_deferred("disabled", false)
	clean_toilet.set_deferred("disabled", false)

func _on_dialogue_timer_timeout():
	dialogue_text.hide()
	

func _on_clean_entered(body, node_name):
	interact_text.text = "[E] Clean"
	interact_text.show()
	canClean = true
	currentNode = node_name


func _on_clean_exited(body):
	interact_text.hide()
	canClean = false

func _on_trash_can_body_entered(body):
	interact_text.text = "[E] Throw away"
	interact_text.show()
	canThrowAway = true


func _on_trash_can_body_exited(body):
	interact_text.hide()
	canThrowAway = false

func showDialogue(text):
	dialogue_text.text = text
	dialogue_text.show()
	dialogue_timer.start(3)
