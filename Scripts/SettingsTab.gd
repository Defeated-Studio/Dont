extends Control


var General_volume


func _on_geral_slider_value_changed(value):
	General_volume = linear_to_db(value/100)
	AudioServer.set_bus_volume_db(0, General_volume)


func _on_music_slider_value_changed(value):
	pass # Replace with function body.
