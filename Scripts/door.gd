extends StaticBody3D

@onready var doorText = $doorText/doorLabel
@onready var animation = $DoorAnimation
@onready var doorOpenSound = $A_DoorOpen

var doorOpen = false
var canOpenDoor = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("OpenDoor") and !doorOpen) and canOpenDoor:
		animation.play("DoorOpen")
		doorOpenSound.play()
		setdoorOpen(!doorOpen)
		doorText.hide()
	elif (Input.is_action_just_pressed("OpenDoor") and doorOpen) and canOpenDoor:
		animation.play_backwards("DoorOpen")
		setdoorOpen(!doorOpen)
		doorText.hide()
	
func setdoorOpen(value):
	doorOpen = value
	

func setcanOpenDoor(value):
	canOpenDoor = value
	
	if value:
		if doorOpen:
			doorText.text = "[E] Close door"
		else:
			doorText.text = "[E] Open door"
		doorText.show()
	else:
		doorText.hide()
