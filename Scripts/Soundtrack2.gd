extends Node3D

@onready var front_door = %House/FrontDoor
@onready var player = %Player
@onready var first_soundtrack = $FirstSoundtrack
@onready var second_soundtrack = $SecondSoundtrack
@onready var third_soundtrack = $ThirdSoundtrack
@onready var fourth_sound_track = $FourthSoundTrack

var insideArea = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if front_door.getState():	# Porta aberta
		change_volume(first_soundtrack, 15)
	elif player.ground == "Grass" or insideArea:
		change_volume(first_soundtrack, 15)
	else:
		change_volume(first_soundtrack, 10)


func change_volume(soundtrack, db):
	soundtrack.volume_db = db

func fadeInAudio(audio, db):
	audio.play()
	var tween = get_tree().create_tween()
	tween.tween_property(audio, "volume_db", db, 5)
	
func fadeOutAudio(audio):
	var tween = get_tree().create_tween()
	tween.tween_property(audio, "volume_db", -80, 12)
	await get_tree().create_timer(12).timeout
	audio.stop()

func _on_area_3d_body_entered(body):
	insideArea = true


func _on_area_3d_body_exited(body):
	insideArea = false
