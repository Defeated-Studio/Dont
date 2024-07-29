extends Node3D

@onready var soundtrack = $Soundtrack
@onready var front_door = %House/FrontDoor
@onready var player = %Player

var insideArea = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if front_door.getState():	# Porta aberta
		change_volume(10)
	elif player.ground == "Grass" or insideArea:
		change_volume(10)
	else:
		change_volume(0)


func change_volume(db):
	soundtrack.volume_db = db


func _on_area_3d_body_entered(body):
	insideArea = true


func _on_area_3d_body_exited(body):
	insideArea = false
