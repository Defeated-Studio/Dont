extends Node3D

#@onready var doorOpenSound = $A_DoorOpen
@onready var doorText = $Door/DoorText
@onready var animation = $Door/DoorAnimation
@onready var doorShutSound = $AudioStreamPlayer3D
@onready var locked_text = $Door/LockedText

@export var locked = false

var doorOpen = false
var canOpenDoor = false
static var shutDoor = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ((Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("LeftMouseButton")) and !doorOpen) and canOpenDoor and IsRayCasting.canInteract:
		if locked:
			locked_text.show()
			return
			
		animation.play("OpenDoorAni")
		#doorOpenSound.play()
		setdoorOpen(!doorOpen)
		doorText.hide()
	elif ((Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("LeftMouseButton")) and doorOpen) and canOpenDoor and IsRayCasting.canInteract:
		if shutDoor and self.name == "FrontDoor":
			animation.play("ShutDoor")
			setdoorOpen(!doorOpen)
			doorText.hide()
			shutDoor = false
			doorShutSound.play()
		else:
			animation.play_backwards("OpenDoorAni")
			setdoorOpen(!doorOpen)
			doorText.hide()
	
func setdoorOpen(value):
	doorOpen = value
	

func setcanOpenDoor(value):
	canOpenDoor = value
	
	if value:
		if doorOpen:
			doorText.text = "[E] Fechar Porta"
		else:
			doorText.text = "[E] Abrir Porta"
		doorText.show()
	else:
		locked_text.hide()
		doorText.hide()


func _on_door_event_body_entered(body):
	setcanOpenDoor(true)


func _on_door_event_body_exited(body):
	setcanOpenDoor(false)
