extends Node3D
@onready var player = %Player
@onready var player_camera = %Player/Head/Camera3D
@onready var player_head = %Player/Head
@onready var dialogue_text = %Player/DialogueText
@onready var position_target = $EatArea/PositionTarget

@onready var quest_control = $"../QuestControl"
@onready var interact_text = %InteractText

@onready var world = $".."

@onready var timer_sleep_task = $"../SleepTask/TimerSleepTask"

@onready var geladeira_area = $GeladeiraArea
@onready var plate_area = $PlateArea
@onready var forno_area = $FornoArea
@onready var eat_area = $EatArea

@onready var pizza_box = $"../Player/PizzaBox"
@onready var pizza = $Pizza
@onready var metal_plate = $"../House/Kitchen/MetalPlate"

@onready var pizza_mesa = $PizzaMesa
@onready var first_piece = $PizzaMesa/Pizzanova/FirstPiece
@onready var second_piece = $PizzaMesa/Pizzanova/SecondPiece
@onready var third_piece = $PizzaMesa/Pizzanova/ThirdPiece
@onready var fourth_piece = $PizzaMesa/Pizzanova/FourthPiece
@onready var pizza_pieces = [first_piece, second_piece, third_piece, fourth_piece]

@onready var oven_timer = $OvenTimer
@onready var oven_sound = $OvenSound
@onready var eating_pizza = $EatingPizza

@onready var skin_walker = $SkinWalker
@onready var skin_walker_animation_player = $SkinWalker/AnimationPlayer
@onready var hand = $Hand
@onready var hand_animation_player = $Hand/AnimationPlayer
@onready var hand2 = $Hand2
@onready var hand2_animation_player = $Hand2/AnimationPlayer
@onready var appear_animation_player = $SkinWalker/Appear/AnimationPlayer
@onready var heartbeat = $Heartbeat

var canPickUpPizzaBox = false
var PizzaBox = false

var canPutPizzaOnPlate = false
var PizzaAndPlate = false

var canPutPizzaOnOven = false
var PizzaReady = false
var canPickUpPizza = false

var onWindow = false

var readyToEat = false
var canSitDown = false
var canEat = false
var canEatAgain = true
var eatCount = 0
var playerLastPosition = Vector3.ZERO

func _ready():
	geladeira_area.monitoring = false
	
func _on_oven_timer_timeout():
	oven_sound.play()
	oven_timer.stop()
	PizzaReady = true
	player.canMove = true
	player.canMoveCamera = true
	player.canUseFlashlight = true
	dialogue_text.queueDialogue("que PORRA foi essa??")
	dialogue_text.queueDialogue("acho que to vendo coisa")
	dialogue_text.queueDialogue("ficou pronto...")
	dialogue_text.timeBetweenText = 3
	dialogue_text.showDialogue()
	onWindow = false
	world.canOpenMobile = true
	hide_everything()
	
func _physics_process(delta):
	if ((Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("LeftMouseButton")) and canPickUpPizzaBox):
		canPickUpPizzaBox = false
		PizzaBox = true
		pizza_box.show()
		geladeira_area.queue_free()
		interact_text.hide()
		
		dialogue_text.queueDialogue("beleza, melhor do que aquele lixo que comi ontem")
		dialogue_text.queueDialogue("preciso colocar em uma forma de pizza")
		dialogue_text.timeBetweenText = 2
		dialogue_text.showDialogue()
		
	if ((Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("LeftMouseButton")) and canPutPizzaOnPlate): 
		canPutPizzaOnPlate = false
		PizzaAndPlate = true
		pizza_box.hide()
		pizza.show()
		plate_area.queue_free()
		interact_text.hide()
		
		metal_plate.reparent(player)
		pizza.reparent(player)
		
		dialogue_text.queueDialogue("só colocar no forno agora")
		dialogue_text.timeBetweenText = 2
		dialogue_text.showDialogue()
		
	if ((Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("LeftMouseButton")) and canPutPizzaOnOven): 
		canPutPizzaOnOven = false
		PizzaAndPlate = false
		metal_plate.hide()
		pizza.hide()
		interact_text.hide()
		world.canOpenMobile = false
		
		dialogue_text.queueDialogue("só esperar")
		dialogue_text.timeBetweenText = 2
		dialogue_text.showDialogue()
		
		await get_tree().create_timer(1).timeout
		SceneTransition.change_scene("", "quickTransition", 0)
		player.canMove = false
		player.canMoveCamera = false
		player.canUseFlashlight = false
		
		await get_tree().create_timer(1).timeout
		teleport_player()
		
		await get_tree().create_timer(2).timeout
		dialogue_text.queueDialogue("cara, o que eu faço?")
		dialogue_text.queueDialogue("tudo deu errado, to basicamente preso nesse fim de mundo")
		dialogue_text.queueDialogue("eu só queria poder voltar no tempo")
		dialogue_text.timeBetweenText = 3
		dialogue_text.showDialogue()
		
		await get_tree().create_timer(10).timeout
		onWindow = true
		oven_timer.start()
		
	if (onWindow):

		if !skin_walker_animation_player.is_playing():	
			skin_walker_animation_player.play("idle")
		if !skin_walker.visible:
			skin_walker.show()
			appear_animation_player.play("appear")
			
		if !hand_animation_player.is_playing():
			hand_animation_player.play("idle")
			hand2_animation_player.play("idle")
		hand.show()
		hand2.show()
		
		player_head.position.z -= 0.02 * delta
		
		await get_tree().create_timer(3).timeout
		if (!heartbeat.playing):
			heartbeat.play()

		if hand.position.x >= 7.88:
			hand.position.x -= 0.05 * delta
			
		if hand2.position.x <= 2.8:
			hand2.position.x += 0.05 * delta
		
	if ((Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("LeftMouseButton")) and canPickUpPizza): 
		canPickUpPizza = false
		
		metal_plate.show()
		pizza.show()
		forno_area.queue_free()
		
		dialogue_text.queueDialogue("pelo menos ficou bom")
		dialogue_text.queueDialogue("não tem tv, vou de mesa")
		dialogue_text.timeBetweenText = 2
		dialogue_text.showDialogue()
		
		readyToEat = true
	
	
	if ((Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("LeftMouseButton")) and canSitDown): 
		SceneTransition.change_scene("", "quickTransition", 0)
		await get_tree().create_timer(1).timeout
		interact_text.hide()
		readyToEat = false
		canSitDown = false
		playerLastPosition = player.global_position
		player.global_position = position_target.get_global_transform().origin
		player.set_rotation_degrees(Vector3(0, 180, 0))
		player.canMove = false
		player.canUseFlashlight = false
		world.canOpenMobile = false
		pizza_mesa.show()
		pizza.queue_free()
		metal_plate.queue_free()
		canEat = true

	if (IsRayCasting.canInteract and is_instance_valid(IsRayCasting.collider) and IsRayCasting.collider.name == "RaycastPizza" and Input.is_action_just_pressed("LeftMouseButton") and canEat and canEatAgain):
		canEatAgain = false
		eating_pizza.play()
		pizza_pieces[eatCount].queue_free()
		eatCount += 1
		await get_tree().create_timer(5).timeout
		if eatCount == 4:
			finish_quest()
		else:
			canEatAgain = true

func finish_quest():
	SceneTransition.change_scene("", "quickTransition", 0)
	await get_tree().create_timer(1).timeout
	player.global_position = playerLastPosition
	player.canMove = true
	player.canUseFlashlight = true
	world.canOpenMobile = true
	quest_control.finishQuest()
	timer_sleep_task.start()
	self.queue_free()
	
func _on_quest_control_quest_started():
	if quest_control.questActive == 8:
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

func teleport_player():
	player.global_position = Vector3(5.145, 0.541, -1.4)
	player.set_rotation_degrees(Vector3(0, 0, 0))
	player_head.set_rotation_degrees(Vector3(0, 0, 0))

func hide_everything():
	heartbeat.stop()
	skin_walker.hide()
	hand.hide()
	hand2.hide()


func _on_eat_area_body_entered(body):
	if readyToEat:
		interact_text.text = "[E] Sentar"
		interact_text.show()
		canSitDown = true
