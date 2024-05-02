extends Node3D

var canPickUp = false
@onready var interact_text = $"../InteractText/InteractText"
@onready var ui = $UI


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("interact") and canPickUp:
		ui.show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		


func _on_interact_area_body_entered(body):
	canPickUp = true
	interact_text.text = "[E] Pegar"
	interact_text.show()


func _on_interact_area_body_exited(body):
	canPickUp = false
	interact_text.hide()


func _on_close_button_pressed():
	ui.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
