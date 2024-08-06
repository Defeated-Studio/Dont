extends Node3D

@onready var front_door = %House/FrontDoor
@onready var player = %Player
@onready var first_soundtrack = $FirstSoundtrack
@onready var second_soundtrack = $SecondSoundtrack

var insideArea = false

var playFirst = true
var playSecond = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playFirst:
		manageAudio(first_soundtrack, 8)
	elif playSecond:
		manageAudio(second_soundtrack, 10)

func manageAudio(audio, db):
	if front_door.getState():	# Porta aberta
		change_volume(audio, db+5)
	elif player.ground == "Grass" or insideArea:
		change_volume(audio, db+5)
	else:
		change_volume(audio, db)

func change_volume(soundtrack, db):
	soundtrack.volume_db = db

func fadeInAudio(audio, db):
	audio.play()
	var tween = get_tree().create_tween()
	tween.tween_property(audio, "volume_db", db, 2.5)
	
func fadeOutAudio(audio):
	var tween = get_tree().create_tween()
	tween.tween_property(audio, "volume_db", -80, 12)

func _on_area_3d_body_entered(body):
	if body.name != "Mom":
		insideArea = true


func _on_area_3d_body_exited(body):
	if body.name != "Mom":
		insideArea = false
