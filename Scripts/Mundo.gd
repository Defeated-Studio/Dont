extends Node3D


@onready var messages_app = $"../../MessagesApp"
@onready var player = $Player
@onready var diary = $"../../Diary"

var canOpenMobile = true
var canOpenDiary = true

func _ready():
	#Engine.max_fps = 144
	pass


func _process(delta):
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
