extends Node3D

@onready var animation_player = $AnimationPlayer
@onready var curtain_text = $CurtainText

var canClose = false
var CurtainOpened = true


func _process(delta):
	if CurtainOpened:
		curtain_text.text = "[E] Open"
	else:
		curtain_text.text = "[E] Close"
		
		
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
