extends Node3D


@onready var messages_app = $"../../MessagesApp"
@onready var player = $Player
@onready var crosshair = $Player/Head/InteractRay/Control
@onready var flashlight = $Player/Head/FlashlightModel
@onready var diary = $"../../Diary/Diary_UI"
@onready var peephole_camera = $House/FrontDoor/Door/PeepHole/Camera3D
@onready var transition = $House/FrontDoor/Door/PeepHole/AnimationPlayer
@onready var peephole_text = $House/FrontDoor/Door/PeepHole/PeepHoleText
@onready var door_text = $House/FrontDoor/Door/DoorText
@onready var fisheye = $"../../Fisheye"
@onready var pause_menu = $"../../PauseMenu"


var canOpenMobile = true
var inPeepHole = false

func _ready():
	#Engine.max_fps = 144
	pass
	
func _notification(what):
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		pause_menu.inputPrev = Input.mouse_mode
		pause_menu.pause()
				
func _process(delta):
	$FPSCounter.set_text("FPS: %d" % Engine.get_frames_per_second())
	
	if Input.is_action_just_pressed("esc"):
		pause_menu.inputPrev = Input.mouse_mode
		
		pause_menu.move_to_front()
		pause_menu.pause()
	
	if Input.is_action_just_pressed("LeftMouseButton") and IsRayCasting.canInteract and (is_instance_valid(IsRayCasting.collider)) and IsRayCasting.collider.name == "PeepHoleRay" and !inPeepHole:
		player.canMove = false
		player.canMoveCamera = false
		player.canUseFlashlight = false
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
		flashlight.hide()
	
	if Input.is_action_just_pressed("interact") and inPeepHole:
		peephole_text.hide()
		transition.play("peephole")
		await get_tree().create_timer(1.1).timeout
		fisheye.hide()
		player.canMove = true
		player.canMoveCamera = true
		player.canUseFlashlight = true
		canOpenMobile = true
		transition.play_backwards("peephole")
		inPeepHole = false
		peephole_camera.set_current(false)
		crosshair.show()
		flashlight.show()
	
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
