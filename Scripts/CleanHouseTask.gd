extends Node3D

@onready var trigger_clean_house_task = $TriggerCleanHouseTask
@onready var quest_control = $"../QuestControl"
@onready var player_dialogue = $"../Player/DialogueText"
@onready var interact_text = $"../InteractText/InteractText"

@onready var toilet = $"../House/Bathroom2/Toilet"
@onready var clean_sodas = $CleanSodas/CleanSodas
@onready var clean_pizza = $CleanPizza/CleanPizza
@onready var clean_living_room_plates = $CleanLivingRoomPlates/CleanLivingRoomPlates
@onready var clean_kitchen_plates = $CleanKitchenPlates/CleanKitchenPlates
@onready var clean_cereal = $CleanCereal/CleanCereal
@onready var clean_toilet = $CleanToilet/CleanToilet
@onready var trash = $TrashCan/Trash

@onready var paper1 = $Paper1
@onready var paper_collision = $Paper1/InteractArea/CollisionShape3D

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
			player_dialogue.queueDialogue("acho que terminei, preciso jogar isso fora.")
			player_dialogue.showDialogue()
			trash.set_deferred("disabled", false) 
	
	if Input.is_action_just_pressed("interact") and canThrowAway:
		quest_control.finishQuest()
		get_node("TrashCan").queue_free()
		await get_tree().create_timer(1.0).timeout
		player_dialogue.timeBetweenText = 3
		player_dialogue.queueDialogue("essa casa não parece certa, sinto algo estranho.")
		player_dialogue.queueDialogue("posso jurar que as fotos do anúncio estavam diferentes")
		player_dialogue.queueDialogue("vou chamar o bob e resolver isso")
		player_dialogue.showDialogue()
		quest_control.startQuest()

func _on_trigger_clean_house_task_body_entered(body):
	if quest_control.questActive == 1:
		paper1.show()
		paper_collision.set_deferred("disabled", false)
		player_dialogue.queueDialogue("essa casa tá uma bagunça, preciso limpar isso.")
		player_dialogue.showDialogue()
		activateCollisions()
		get_node("TriggerCleanHouseTask").queue_free()
		await get_tree().create_timer(3.0).timeout
		quest_control.startQuest()
	else:
		player_dialogue.queueDialogue("que escuridão, melhor eu achar essa porra de gerador.")
		player_dialogue.showDialogue()
		pass


func activateCollisions():
	clean_sodas.set_deferred("disabled", false)
	clean_pizza.set_deferred("disabled", false)
	clean_living_room_plates.set_deferred("disabled", false)
	clean_kitchen_plates.set_deferred("disabled", false)
	clean_cereal.set_deferred("disabled", false)
	clean_toilet.set_deferred("disabled", false)

func _on_clean_entered(body, node_name):
	interact_text.text = "[E] Limpar"
	interact_text.show()
	canClean = true
	currentNode = node_name


func _on_clean_exited(body):
	interact_text.hide()
	canClean = false

func _on_trash_can_body_entered(body):
	interact_text.text = "[E] Jogar Fora"
	interact_text.show()
	canThrowAway = true


func _on_trash_can_body_exited(body):
	interact_text.hide()
	canThrowAway = false
