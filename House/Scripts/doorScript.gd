extends Node3D

#@onready var doorOpenSound = $A_DoorOpen
@onready var doorText = $Door/DoorText
@onready var animation = $Door/DoorAnimation
@onready var doorShutSound = $AudioStreamPlayer3D
@onready var locked_text = $Door/LockedText
@onready var door = $Door

@export var locked = false

var doorOpen = false
var canOpenDoor = false
static var shutDoor = true

func getState():
	return doorOpen

func setState(state):
	if state:
		door.rotation.z = 1.85004997253418
		doorOpen = true
	else:
		door.rotation.z = 0
		doorOpen = false
		
func setStateAnimation(state):
	if state:
		animation.play("OpenDoorAni")
		setdoorOpen(!doorOpen)
	else:
		animation.play_backwards("OpenDoorAni")
		setdoorOpen(!doorOpen)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ((Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("LeftMouseButton")) and !doorOpen) and canOpenDoor and IsRayCasting.canInteract and ("Door" in IsRayCasting.collider.name):
		if locked:
			locked_text.show()
			return
			
		animation.play("OpenDoorAni")
		#doorOpenSound.play()
		setdoorOpen(!doorOpen)
		doorText.hide()
		
	elif ((Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("LeftMouseButton")) and doorOpen) and canOpenDoor and IsRayCasting.canInteract and ("Door" in IsRayCasting.collider.name):
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
	if body.name == "Mom":
		if !doorOpen:
			animation.play("OpenDoorAni")
			setdoorOpen(!doorOpen)
	else :
		setcanOpenDoor(true)
	
func _on_door_event_body_exited(body):
	if body.name != "Mom":
		setcanOpenDoor(false)
