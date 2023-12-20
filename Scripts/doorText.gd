extends Control

@onready var doorText = $door

# Called when the node enters the scene tree for the first time.
func _ready():
	doorText.text = "[E] Open door"
	doorText.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
