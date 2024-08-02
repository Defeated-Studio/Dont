extends Node3D

@onready var door_knock = $DoorKnock
@onready var dialogue_text = %Player/DialogueText
@onready var world_environment = $"../WorldEnvironment".environment
@onready var world = $".."
@onready var timer = $Timer
@onready var player = %Player

@onready var peep_hole_text = $PeepHoleText
@onready var couch_1 = %House/LivingRoom/Couch1
@onready var move_sofa = $MoveSofa
@onready var front_door = %House/FrontDoor

@onready var skin_walker = %SkinWalker
@onready var skin_walker_anim = $SkinWalker/AnimationPlayer
@onready var mom = $Mom
@onready var paper = $Paper

@onready var blood_marks = $BloodMarks
@onready var blood_marks_2 = $BloodMarks2

@onready var skin_walker_final = $SkinWalkerFinal
@onready var skin_walker_final_ray = $SkinWalkerFinal/SkinWalkerFinalRay

@onready var jumpscare = $jumpscare
@onready var gore = $Gore

@onready var target_position = $TargetPosition
@onready var car = $"../Car"
@onready var car_running = $"../Car/CarRunning"
@onready var player_skin_walker = $"../Player/PlayerSkinWalker"

@onready var player_head = %Player/Head

var audioCanPlay = false
var canPeepHole = false
var inPeepHole = false
var hasSeenPeepHole = false
var canMoveSofa = false
var canDie = false
var dead = false
var finished = false

func _ready():
	front_door.setDoorMonitoring(false)
	door_knock.play()
	
	world_environment.background_energy_multiplier = 0.5
	dialogue_text.timeBetweenText = 3
	dialogue_text.queueDialogue("finalmente, só pode ser minha mãe")
	dialogue_text.showDialogue()
	

func teleportPlayer():
	player.global_position = target_position.global_position
	
func _process(delta):
	if front_door.getState():
		front_door.setDoorMonitoring(false)
	
	if canDie and (is_instance_valid(IsRayCasting.collider)) and IsRayCasting.collider.name == "SkinWalkerFinalRay":
		canDie = false
		jumpscare.play(0.4)
		skin_walker_final.look_at(player.global_position)
		player.look_at(skin_walker_final.global_position, Vector3.UP)
		player.head.set_rotation_degrees(Vector3(5, 0, 0))
		player.camera.fov = 25.0
		player.change_input_flags(false)
		SceneTransition.change_scene("", "LastKillScreen", 0)
		await get_tree().create_timer(10).timeout
		SceneTransition.change_scene("", "Dissolve", 0)
		teleportPlayer()
		car.show()
		dead = true
		player.camera.fov = 45.0
		car_running.start()
		player_skin_walker.show()
		
	if dead and !car.arrived:
		player.look_at(car.global_position)
	
	if dead and car.arrived and !finished:
		finished = true
		await get_tree().create_timer(1).timeout
		var tween = get_tree().create_tween()
		player.camera.fov = 45.0
		tween.tween_property(player_head, "rotation_degrees", Vector3(-75, 0, 0), 3)
		
		await get_tree().create_timer(4).timeout
		SceneTransition.change_scene("", "LastKillScreen", 0)
		await get_tree().create_timer(2).timeout
		SceneTransition.change_scene("", "Dissolve", 0)
		SaverLoader.delete_save()
		get_tree().change_scene_to_file("res://Scenes/Screens/MainMenu.tscn")
		
	if skin_walker.visible:
		skin_walker.position.z -= 2.5 * delta
	
	if audioCanPlay:
		if !door_knock.playing:
			await get_tree().create_timer(0.5).timeout
			door_knock.play()
	
	if canPeepHole and !hasSeenPeepHole and Input.is_action_just_pressed("PeepHole") and !inPeepHole:
		audioCanPlay = false
		door_knock.stop()
		world.showPeepHole()
		inPeepHole = true
		hasSeenPeepHole = true
		skin_walker.show()
		skin_walker_anim.play("Walk")
		
	elif inPeepHole and hasSeenPeepHole:
		timer.start()
		inPeepHole = false
		
	elif (Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("LeftMouseButton") or Input.is_action_just_pressed("PeepHole")) and inPeepHole:
		pass
	
	if hasSeenPeepHole and canMoveSofa and Input.is_action_just_pressed("PeepHole"):
		player.change_input_flags(false)
		canMoveSofa = false
		get_node("InteractArea").queue_free()
		SceneTransition.change_scene("", "quickTransition", 0)
		await get_tree().create_timer(1).timeout
		couch_1.position = Vector3(-0.816, 0.738, 2.588)
		couch_1.rotation_degrees = Vector3(0, 60, 0)
		move_sofa.play()
		player.change_input_flags(true)
		peep_hole_text.hide()
		front_door.setDoorMonitoring(true)
		paper.show()
		blood_marks.show()
		blood_marks_2.show()
		gore.play()

func _on_interact_area_body_entered(body):
	if !hasSeenPeepHole:
		peep_hole_text.text = "[Q] Olhar olho mágico"
		peep_hole_text.show()
		canPeepHole = true

func _on_interact_area_body_exited(body):
	peep_hole_text.hide()
	canPeepHole = false


func _on_timer_timeout():
	world.hidePeepHole()
	peep_hole_text.text = "[Q] Mover Sofá"
	peep_hole_text.show()
	canMoveSofa = true
	await get_tree().create_timer(0.9).timeout
	skin_walker.hide()
	mom.hide()
	dialogue_text.timeBetweenText = 3
	dialogue_text.queueDialogue("MÃE CUIDADO")
	dialogue_text.showDialogue()


func _on_paper_close():
	skin_walker_final.show()
	skin_walker_final_ray.monitoring = true
	canDie = true
	
