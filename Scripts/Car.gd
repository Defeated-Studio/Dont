extends Node3D

var arrived = false
var vel = 2.5
@onready var car_running = $CarRunning
@onready var car_engine = $CarEngine
@onready var animation_player = $CarModel/AnimationPlayer

func _process(delta):
	if self.visible and !arrived:
		if !car_engine.playing:
			car_engine.play()
		if car_running.time_left <= 2.5:
			vel = car_running.time_left
			
		self.position.z -= vel * delta


func _on_car_running_timeout():
	arrived = true
	car_running.stop()
	car_engine.stop()
	animation_player.stop()
	
