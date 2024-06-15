extends Node3D

var canPickUp = false

@onready var diary = $Diary_UI
@onready var interact_text = %InteractText
@onready var player = $"../SubViewport/World/Player"

func _ready():
	pass 


func _process(delta):
	if Input.is_action_just_pressed("interact") and canPickUp:
		player.canMove = false;
		player.canMoveCamera = false;
		diary.show();
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
	pass


func _on_interact_area_body_entered(body):
	canPickUp = true;
	interact_text.text = "[E] Abrir";
	interact_text.show();


func _on_interact_area_body_exited(body):
	canPickUp = false;
	interact_text.hide();

func _on_close_button_pressed():
	diary.hide();
	player.canMove = true;
	player.canMoveCamera = true;
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
