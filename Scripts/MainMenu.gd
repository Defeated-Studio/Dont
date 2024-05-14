extends Control

const INITIAL_SCREEN = preload("res://Scenes/Screens/InitialScreen.tscn")
@onready var options_menu = $OptionsMenu
@onready var margin_container = $MarginContainer

func _ready():
	pass

func _process(delta):
	pass


func _on_new_game_pressed():
	get_tree().change_scene_to_packed(INITIAL_SCREEN)


func _on_options_pressed():
	margin_container.visible = false
	options_menu.set_process(true)
	options_menu.visible = true


func _on_quit_pressed():
	get_tree().quit()


func _on_options_menu_exit_options_menu():
	options_menu.visible = false
	margin_container.visible = true
