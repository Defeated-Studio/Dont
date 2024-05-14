extends Control

signal exit_options_menu()

func _ready():
	set_process(false)


func _on_exit_pressed():
	emit_signal("exit_options_menu")
	set_process(false)
