extends Node3D

var next_scene: String
signal saved_game_signal

func save_game(night: int):
	var saved_game:SavedGame = SavedGame.new()
	
	saved_game.night = night
	saved_game.states = NodeStates.states
	saved_game.papers_taken = NodeStates.papers_taken
	
	ResourceSaver.save(saved_game, "user://dont_save_game.tres")
	saved_game_signal.emit()

func load_game():
	var saved_game:SavedGame = load("user://dont_save_game.tres") as SavedGame

	NodeStates.states = saved_game.states 
	NodeStates.papers_taken = saved_game.papers_taken

	match saved_game.night:
		1:
			next_scene = "res://Scenes/Night1.tscn"
		2:
			next_scene = "res://Scenes/Night2.tscn"
		3:
			next_scene = "res://Scenes/Night3.tscn"
		4:
			next_scene = "res://Scenes/Night4.tscn"
		5:
			next_scene = "res://Scenes/Night5.tscn"
		_:
			push_error("Noite inválida.") 
			return
			
	get_tree().change_scene_to_file("res://Scenes/Screens/LoadingScreen.tscn")

func delete_save():
	var file_path = "user://dont_save_game.tres"
	if ResourceLoader.exists("user://dont_save_game.tres"):
		var dir = DirAccess
		DirAccess.remove_absolute("user://dont_save_game.tres")
