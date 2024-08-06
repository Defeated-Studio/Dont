extends Node3D

@onready var door_break_open = $doorBreakOpen
@onready var paper = $Paper

@onready var dialogue_text = %Player/DialogueText
@onready var front_door = %House/FrontDoor
@onready var mom = $Mom
@onready var quest_control = $"../QuestControl"
@onready var interact_text = %InteractText
@onready var position_target = $position
@onready var player = %Player
@onready var hiding_camera = $HidingCamera
@onready var microfone = $"../../../Microfone"
@onready var walk_sound = $Mom/WalkSound
@onready var skin_walker = $SkinWalker
@onready var skin_walker_2 = $SkinWalker2
@onready var death = $"../../../Death"
@onready var mom_col = $Mom/CollisionShape3D


@onready var target_1 = $Target1
@onready var target_2 = $Target2
@onready var target_3 = $Target3
@onready var target_4 = $Target4

@onready var soundtrack = $"../../../Soundtrack4"
@onready var first_soundtrack = $"../../../Soundtrack4/FirstSoundtrack"
@onready var second_soundtrack = $"../../../Soundtrack4/SecondSoundtrack"


var canFollowPlayer = false
var canHideWrongSpot = false
var canHideRightSpot = false
var hiding = false
var volume_exceeded = false


func _ready():
	soundtrack.fadeInAudio(first_soundtrack, 8)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if canHideWrongSpot and Input.is_action_just_pressed("interact"):
		dialogue_text.timeBetweenText = 3.5
		dialogue_text.queueDialogue("não consigo me esconder aqui, preciso achar outro lugar")
		dialogue_text.showDialogue()
		
	if canHideRightSpot and !hiding and Input.is_action_just_pressed("interact"):
		hideSpot()
		hiding = true
	
	elif hiding and (Input.is_action_just_pressed("interact")):
		exitSpot()
		hiding = false
	
	if canFollowPlayer:
		if !hiding:
			mom.target = player
		elif !volume_exceeded:
			mom.target = mom.previous_target
			if microfone.final_volume >= 100:
				volume_exceeded = true
		elif volume_exceeded:
			mom.target = player

func exitSpot():
	SceneTransition.change_scene("", "quickTransition", 0)
	player.change_input_flags(true)
	await get_tree().create_timer(1).timeout
	hiding_camera.set_current(false)
	interact_text.hide()
	microfone.hide()

func hideSpot():
	SceneTransition.change_scene("", "quickTransition", 0)
	player.change_input_flags(false)
	await get_tree().create_timer(1).timeout
	player.global_position = position_target.get_global_transform().origin
	player.set_rotation_degrees(Vector3(0, 90, 0))
	hiding_camera.set_current(true)
	interact_text.text = "[E] Sair"
	interact_text.show()
	microfone.show()

func _on_paper_close():
	quest_control.finishQuest()
	quest_control.startQuest()
	#door_break_open.play()
	await get_tree().create_timer(0.5).timeout
	soundtrack.playFirst = false
	soundtrack.playSecond = true
	first_soundtrack.stop()
	second_soundtrack.play()
	dialogue_text.timeBetweenText = 2.5
	dialogue_text.queueDialogue("O QUE FOI ISSO?")
	dialogue_text.showDialogue()
	front_door.setState(true)
	
	mom.previous_target = target_1
	mom.target = target_1
	mom.show()
	mom.following = true
	mom_col.set_deferred("disabled", false)
	walk_sound.play()

func _on_wrong_spot_body_entered(body):
	if quest_control.questActive == 15 and body.name != "Mom":
		interact_text.text = "[E] Esconder"
		interact_text.show()
		canHideWrongSpot = true

func _on_wrong_spot_body_exited(body):
	if quest_control.questActive == 15 and body.name != "Mom":
		interact_text.hide()
		canHideWrongSpot = false

func _on_right_spot_body_entered(body):
	if quest_control.questActive == 15 and body.name != "Mom":
		interact_text.text = "[E] Esconder"
		interact_text.show()
		canHideRightSpot = true

func _on_right_spot_body_exited(body):
	if quest_control.questActive == 15 and body.name != "Mom":
		interact_text.hide()
		canHideRightSpot = false

func _on_navigation_agent_3d_target_reached():
	if mom.target == target_1:
		walk_sound.stop()
		await get_tree().create_timer(2).timeout
		if !walk_sound.playing:
			walk_sound.play()
		mom.target = target_2
		mom.previous_target = target_2
		canFollowPlayer = true
		
	elif mom.target == target_2:
		walk_sound.stop()
		await get_tree().create_timer(2).timeout
		if !walk_sound.playing:
			walk_sound.play()
		mom.target = target_3
		mom.previous_target = target_3
		
	elif mom.target == target_3:
		walk_sound.stop()
		await get_tree().create_timer(2).timeout
		if !walk_sound.playing:
			walk_sound.play()
		mom.target = target_4
		mom.previous_target = target_4
		
	elif mom.target == target_4 and quest_control.questActive == 15:
		walk_sound.stop()
		mom.hide()
		mom_col.set_deferred("disabled", true)
		mom.following = false
		quest_control.finishQuest()
		quest_control.startQuest()
		finishQuestDialogue()
		setFlags(false)

	elif mom.target == player and hiding:
		mom.following = false
		mom.target = null
		mom.hide()
		walk_sound.stop()
		await get_tree().create_timer(2).timeout
		skin_walker.show()
		skin_walker_2.show()
		var tween = get_tree().create_tween()
		tween.tween_property(hiding_camera, "rotation_degrees", Vector3(0, -180, 0), 0.1)
		await get_tree().create_timer(0.1).timeout
		death.appear()
	
	elif mom.target == player and !hiding:
		skin_walker.global_position = mom.global_position
		skin_walker.look_at(player.global_position)
		mom.hide()
		skin_walker.show()
		player.look_at(skin_walker.global_position, Vector3.UP)
		player.head.set_rotation_degrees(Vector3(40, 0, 0))
		player.camera.fov = 25.0
		death.appear()

func finishQuestDialogue():
	dialogue_text.timeBetweenText = 3
	dialogue_text.queueDialogue("talvez ela tenha ido embora")
	dialogue_text.showDialogue()

func setFlags(value):
	canHideWrongSpot = value
	canHideRightSpot = value
