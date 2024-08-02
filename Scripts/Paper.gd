extends Node3D

@export var id: int
@export_multiline var text : String

var canPickUp = false

@onready var interact_text = %InteractText
@onready var player = %Player
@onready var player_dialogue_text = %Player/DialogueText
@onready var paper_model = $PaperModel

@onready var ui = $UI
@onready var text_ui = $UI/Text

@onready var diary = %Diary

signal close


func _ready():
	text_ui.text = text


func _process(delta):
	if Input.is_action_just_pressed("interact") and canPickUp and is_instance_valid(IsRayCasting.collider) and IsRayCasting.collider.name == "RayCast":
		player.canMove = false
		player.canMoveCamera = false
		paper_model.hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		ui.show()
		

func _on_interact_area_body_entered(body):
	if self.visible:
		canPickUp = true
		interact_text.text = "[E] Pegar"
		interact_text.show()

func _on_interact_area_body_exited(body):
	canPickUp = false
	interact_text.hide()

func _on_close_button_pressed():
	close.emit()
	player.canMove = true
	player.canMoveCamera = true
	ui.hide()
	diary.new_paper_taken(id)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if id == 1:
		player_dialogue_text.queueDialogue("isso é sério? sendo observada? meu deus")
		player_dialogue_text.queueDialogue("meu instinto diz pra eu vazar daqui dona Helena")
		player_dialogue_text.timeBetweenText = 3
		player_dialogue_text.showDialogue()
	if id == 2:
		player_dialogue_text.queueDialogue("esse papel apareceu do nada")
		player_dialogue_text.queueDialogue("juro que olhei aqui antes")
		player_dialogue_text.queueDialogue("quem é essa mulher? Por que ela ta me ajudando?")
		player_dialogue_text.timeBetweenText = 3
		player_dialogue_text.showDialogue()
	if id == 3:
		player_dialogue_text.queueDialogue("eu não to ficando louco")
		player_dialogue_text.queueDialogue("deve ter sido isso que eu vi na janela ontem")
		player_dialogue_text.timeBetweenText = 3
		player_dialogue_text.showDialogue()
	if id == 4:
		player_dialogue_text.queueDialogue("???")
		player_dialogue_text.timeBetweenText = 2
		player_dialogue_text.showDialogue()

	self.queue_free()
