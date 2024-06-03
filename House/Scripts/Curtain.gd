extends Node3D

@onready var animation_player = $AnimationPlayer
@onready var curtain_text = $CurtainText
@onready var leftCurt = $"LeftCurt/Plane_001_curtains cloth_0"
@onready var rightCurt = $"RightCurt/Plane_001_curtains cloth_0"

var canClose = false
var CurtainOpened = true

func getState():
	return CurtainOpened

func setState(state):
	if state:
		leftCurt.position.x = 0 
		rightCurt.position.x = 0
		CurtainOpened = true
	else:
		leftCurt.position.x = -0.5
		rightCurt.position.x = 0.5
		CurtainOpened = false

func _process(delta):
	if CurtainOpened:
		curtain_text.text = "[E] Fechar"
	else:
		curtain_text.text = "[E] Abrir"
		
		
	if (Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("LeftMouseButton")) and canClose and IsRayCasting.canInteract:
		if CurtainOpened:
			animation_player.play("Close")
			CurtainOpened = false
		else:
			animation_player.play_backwards("Close")
			CurtainOpened = true

func _on_interact_curt_body_entered(body):
	canClose = true
	curtain_text.show()


func _on_interact_curt_body_exited(body):
	canClose = false
	curtain_text.hide()
