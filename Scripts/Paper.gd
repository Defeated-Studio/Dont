extends Node3D

@export var id: int
@export var text: String

var canPickUp = false

@onready var interact_text = %InteractText
@onready var player = %Player
@onready var player_dialogue_text = %Player/DialogueText
@onready var paper_model = $PaperModel

@onready var ui = $UI
@onready var text_ui = $UI/Text


# Called when the node enters the scene tree for the first time.
func _ready():
	text_ui.text = text 
	pass # Replace with function body.

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("interact") and canPickUp:
		player.canMove = false
		player.canMoveCamera = false
		paper_model.hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		ui.show()
		

func _on_interact_area_body_entered(body):
	canPickUp = true
	interact_text.text = "[E] Pegar"
	interact_text.show()

func _on_interact_area_body_exited(body):
	canPickUp = false
	interact_text.hide()

func _on_close_button_pressed():
	self.queue_free()
	player.canMove = true
	player.canMoveCamera = true
	ui.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if id == 1:
		player_dialogue_text.queueDialogue("O quê? Isso é sério? Deve ser uma piada... Mas e se não for?")
		player_dialogue_text.queueDialogue("Talvez ela só estivesse imaginando coisas.")
		player_dialogue_text.queueDialogue("Talvez eu dê uma olhada na casa amanhã, ver se encontro mais alguma coisa.") 
		player_dialogue_text.queueDialogue("Mas agora... nossa, eu tô cansado demais pra pensar nisso. Preciso limpar isso e dormir um pouco.") 
		player_dialogue_text.timeBetweenText = 4
		player_dialogue_text.showDialogue()
