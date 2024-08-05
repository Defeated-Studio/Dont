extends Node3D

@onready var microfone = $Microfone
@onready var slider = $HSlider
@onready var states = $States

var sensi

func _ready():
	pass

func _process(delta):
	pass

func _on_h_slider_value_changed(value):
	sensi = value / 100
	microfone.change_sensi(sensi)


func _on_button_pressed():
	states.saveMicSensi()
	SaverLoader.next_scene = "res://Scenes/Night1.tscn"
	get_tree().change_scene_to_file("res://Scenes/Screens/LoadingScreen.tscn")
