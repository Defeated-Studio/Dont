extends Control

@onready var microfone = $Microfone
@onready var slider = $HSlider

var sensi

func _ready():
	pass

func _process(delta):
	pass

func _on_h_slider_value_changed(value):
	sensi = value / 100
	microfone.change_sensi(sensi)


func _on_button_pressed():
	pass
