extends Control

@onready var options_menu = $OptionsMenu
@onready var margin_container = $MarginContainer
@onready var load_game = $MarginContainer/VBoxContainer/VBoxContainer/LoadGame
@onready var sound_track = $SoundTrack

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	load_game.disabled = !save_exist()
	var tween = get_tree().create_tween()
	tween.tween_property(sound_track, "volume_db", 0, 2)
	


func _process(delta):
	if !sound_track.playing:
		sound_track.play()
	
func _on_new_game_pressed():
	#SaverLoader.next_scene = "res://Scenes/Night1.tscn"
	#get_tree().change_scene_to_file("res://Scenes/Screens/LoadingScreen.tscn")
	var tween = get_tree().create_tween()
	tween.tween_property(sound_track, "volume_db", -80, 4)
	SceneTransition.change_scene("", "quickTransition", 0)
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://Scenes/Screens/MicScreen.tscn")
	
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
