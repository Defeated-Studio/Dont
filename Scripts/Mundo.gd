extends Node3D


@onready var messages_app = $"../../MessagesApp"
@onready var player = $Player
@onready var crosshair = $Player/Head/InteractRay/Control
@onready var diary = $"../../Diary"
@onready var peephole_camera = $House/FrontDoor/Door/PeepHole/Camera3D
@onready var transition = $House/FrontDoor/Door/PeepHole/AnimationPlayer
@onready var peephole_text = $House/FrontDoor/Door/PeepHole/PeepHoleText
@onready var door_text = $House/FrontDoor/Door/DoorText
@onready var fisheye = $Fisheye

var canOpenMobile = true
var canOpenDiary = true
var inPeepHole = false

func _ready():
	#Engine.max_fps = 144
	pass


func _process(delta):
	if Input.is_action_just_pressed("LeftMouseButton") and IsRayCasting.canInteract and (IsRayCasting.collider) and IsRayCasting.collider.name == "PeepHoleRay" and !inPeepHole:
		player.canMove = false
		player.canMoveCamera = false
		canOpenDiary = false
		canOpenMobile = false
		transition.play("peephole")
		await get_tree().create_timer(1.1).timeout
		peephole_camera.set_current(true)
		transition.play_backwards("peephole")
		inPeepHole = true
		peephole_text.show()
		door_text.hide()
		crosshair.hide()
		fisheye.show()
	
	if Input.is_action_just_pressed("interact") and inPeepHole:
		peephole_text.hide()
		transition.play("peephole")
		await get_tree().create_timer(1.1).timeout
		fisheye.hide()
		player.canMove = true
		player.canMoveCamera = true
		canOpenDiary = true
		canOpenMobile = true
		transition.play_backwards("peephole")
		inPeepHole = false
		peephole_camera.set_current(false)
		crosshair.show()
	
	$FPSCounter.set_text("FPS: %d" % Engine.get_frames_per_second())
	if messages_app.backButtonSignal:
		messages_app.hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		player.canMove = true
		messages_app.backButtonSignal = false
	
	if Input.is_action_just_pressed("Mobile") and !diary.visible and canOpenMobile and !messages_app.visible:
		player.canMove = false
		messages_app.show()
		messages_app.showMobile()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif Input.is_action_just_pressed("Diary") and !messages_app.visible and canOpenDiary:
		if diary.visible:
			diary.hide()
			diary.reset_diary()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			player.canMove = true
		else:
			player.canMove = false
			diary.show()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
