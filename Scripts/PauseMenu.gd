extends Control

@onready var options_menu = $OptionsMenu
@onready var margin_container = $MarginContainer

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


func _on_options_pressed():
	margin_container.visible = false
	options_menu.set_process(true)
	options_menu.visible = true


func _on_options_menu_exit_options_menu():
	options_menu.visible = false
	margin_container.visible = true
