extends Control

const LOADING_SCREEN = preload("res://Scenes/Screens/LoadingScreen.tscn")
@onready var options_menu = $OptionsMenu
@onready var margin_container = $MarginContainer

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(delta):
	pass


func _on_new_game_pressed():
	get_tree().change_scene_to_packed(LOADING_SCREEN)


func _on_options_pressed():
	margin_container.visible = false
	options_menu.set_process(true)
	options_menu.visible = true


func _on_quit_pressed():
	get_tree().quit()


func _on_options_menu_exit_options_menu():
	options_menu.visible = false
	margin_container.visible = true
