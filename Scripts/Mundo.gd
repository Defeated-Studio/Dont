extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	#Engine.max_fps = 144
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$FPSCounter.set_text("FPS %d" % Engine.get_frames_per_second())


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

