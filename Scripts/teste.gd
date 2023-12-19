extends Node3D

@onready var animation = $door/DoorAnimation
@onready var doorOpenSound = $door/A_DoorOpen
var doorOpen = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("OpenDoor") and !doorOpen:
		animation.play("DoorOpen")
		doorOpenSound.play()
		doorOpen = !doorOpen
	elif Input.is_action_just_pressed("OpenDoor") and doorOpen:
		animation.play_backwards("DoorOpen")
		doorOpen = !doorOpen
	
	
	if Input.is_action_pressed("Quit"):
		get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
		get_tree().quit()




func _on_e_open_door_slow_body_entered(body):
	if doorOpen:
		animation.play_backwards("DoorOpenSlow")
		doorOpen = !doorOpen
	else:
		animation.play("DoorOpenSlow")
		doorOpen = !doorOpen

	doorOpenSound.play()
	get_node("E_OpenDoorSlow").queue_free()
