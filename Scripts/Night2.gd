extends SubViewportContainer

@onready var states = $States

# Called when the node enters the scene tree for the first time.
func _ready():
	states.setStates()
