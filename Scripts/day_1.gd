extends Node3D

@onready var beginText = $ingameText/Timer
@onready var characText = $ingameText/gameText
@onready var bedroomDoor = $bedroomDoor
@onready var sleepText = $sleepLabel
@onready var mic = $Microphone
var canSleep = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("Quit"):
		get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
		get_tree().quit()
		
	if Input.is_action_just_pressed("Action") and canSleep:
		var path = get_tree().current_scene.scene_file_path
		var next_day = path.to_int() + 1
		var next_level_path = "res://Scenes/day_" + str(next_day) + ".tscn"
		get_tree().change_scene_to_file(next_level_path)

func _on_e_show_door_interactive_body_entered(body):
	bedroomDoor.setcanOpenDoor(true)
	
func _on_e_show_door_interactive_body_exited(body):
	bedroomDoor.setcanOpenDoor(false)


func _on_e_begin_text_body_entered(body):
	characText.show()
	beginText.start()
	get_node("E_BeginText").queue_free()


func _on_e_open_door_slow_body_entered(body):
	if bedroomDoor.doorOpen:
		bedroomDoor.animation.play_backwards("DoorOpenSlow")
		bedroomDoor.setdoorOpen(!bedroomDoor.doorOpen)
	else:
		bedroomDoor.animation.play("DoorOpenSlow")
		bedroomDoor.setdoorOpen(!bedroomDoor.doorOpen)

	bedroomDoor.doorOpenSound.play()
	get_node("E_OpenDoorSlow").queue_free()


func _on_e_sleep_body_entered(body):
	sleepText.show()
	sleepText.text = "[E] Sleep"
	canSleep = true


func _on_e_sleep_body_exited(body):
	sleepText.hide()
	canSleep = false
