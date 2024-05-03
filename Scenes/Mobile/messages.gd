extends Control

@onready var mom = $Mom
@onready var bob = $Bob
@onready var messages = $Messages

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func showMobile():
	messages.show()
	mom.hide()
	bob.hide()

func _on_mom_button_pressed():
	mom.show()
	messages.hide()


func _on_bob_button_pressed():
	bob.show()
	messages.hide()


func _on_back_button_mom_pressed():
	messages.show()
	mom.hide()
	bob.hide()
