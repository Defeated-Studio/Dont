extends Control

@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("fadeLogo")
	



func _on_animation_player_animation_finished(anim_name):
	get_tree().change_scene_to_file("res://Scenes/Screens/MainMenu.tscn")
