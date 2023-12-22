extends Node3D

@onready var beginText = $ingameText/Timer
@onready var bedroomDoor = $bedroomDoor
@onready var frameAnimation = $womanFrame/AnimationPlayer
@onready var livingRoomDoor = $livingRoomDoor
@onready var flashlight = $Node3D/Camera3D/hand/SpotLight3D
var flashlightOn = false

# Called when the node enters the scene tree for the first time.
func _ready():
	flashlight.hide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Flashlight") and flashlightOn:
		flashlight.hide()
		flashlightOn = !flashlightOn
	elif Input.is_action_just_pressed("Flashlight") and !flashlightOn:
		flashlight.show()
		flashlightOn = !flashlightOn


	if Input.is_action_pressed("Quit"):
		get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
		get_tree().quit()

func _on_e_show_door_interactive_body_entered(body):
	bedroomDoor.setcanOpenDoor(true)
	
func _on_e_show_door_interactive_body_exited(body):
	bedroomDoor.setcanOpenDoor(false)


func _on_e_move_frame_body_entered(body):
	frameAnimation.play("MoveFrame")
	get_node("E_MoveFrame").queue_free()
	beginText.start()

# isso tem que ficar dentro de door.gd se pa, toda porta vai ter esse evento
func _on_e_show_door_interactive_living_room_body_entered(body):
	livingRoomDoor.setcanOpenDoor(true)


func _on_e_show_door_interactive_living_room_body_exited(body):
	livingRoomDoor.setcanOpenDoor(false)
