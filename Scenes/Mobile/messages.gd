extends Control

@onready var mom = $Mom
@onready var bob = $Bob
@onready var messages = $Messages

var inBobWindow = false

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
	inBobWindow = true


func _on_back_button_mom_pressed():
	messages.show()
	mom.hide()
	bob.hide()
	inBobWindow = false
