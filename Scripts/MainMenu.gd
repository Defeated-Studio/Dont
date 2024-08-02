extends Control

@onready var options_menu = $OptionsMenu
@onready var margin_container = $MarginContainer
@onready var load_game = $MarginContainer/VBoxContainer/VBoxContainer/LoadGame

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	load_game.disabled = !save_exist()

func _on_new_game_pressed():
	SaverLoader.next_scene = "res://Scenes/Night1.tscn"
	get_tree().change_scene_to_file("res://Scenes/Screens/LoadingScreen.tscn")

func _on_options_pressed():
	margin_container.visible = false
	options_menu.set_process(true)
	options_menu.visible = true

func _on_quit_pressed():
	get_tree().quit()

func _on_options_menu_exit_options_menu():
	options_menu.visible = false
	margin_container.visible = true

func _on_load_game_pressed():
	SaverLoader.load_game()

func save_exist():
	return ResourceLoader.exists("user://dont_save_game.tres")
