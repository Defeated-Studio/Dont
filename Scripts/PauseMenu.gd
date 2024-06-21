extends Control

var inputPrev = null

func pause():
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	self.show()
	
func unpause():
	self.hide()
	get_tree().paused = false
	Input.set_mouse_mode(inputPrev)
	
func _on_resume_pressed():
	unpause()

func _on_quit_pressed():
	get_tree().quit()

	
