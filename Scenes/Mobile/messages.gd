extends Control

@onready var mom_chat = $"../MomChat"
@onready var bob_chat = $"../BobChat"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mom_button_pressed():
	mom_chat.show()
	self.hide()


func _on_bob_button_pressed():
	bob_chat.show()
	self.hide()
