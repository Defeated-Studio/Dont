extends Node3D

@onready var quest_control = $"../QuestControl"
@onready var dialogue_text = %Player/DialogueText
@onready var world_environment = $"../WorldEnvironment".environment
@onready var player = %Player
@onready var position_target = $Position
@onready var bathroom_1_door = %House/Bathroom1/Bathroom1Door


func _on_quest_control_quest_started():
	if quest_control.questActive == 7:
		await get_tree().create_timer(5).timeout
		dialogue_text.timeBetweenText = 4.5
		dialogue_text.queueDialogue("vou achar algo para fazer e passar o tempo")
		dialogue_text.showDialogue()
		await get_tree().create_timer(1).timeout
		SceneTransition.change_scene("", "SpendTime", 0)
		await get_tree().create_timer(3).timeout
		change_enviroment()
		teleport_player()
		if bathroom_1_door.doorOpen:
			bathroom_1_door.setState(false)
		player.change_input_flags(false)
		await get_tree().create_timer(9).timeout
		player.change_input_flags(true)
		await get_tree().create_timer(1).timeout
		dialogue_text.timeBetweenText = 3
		dialogue_text.queueDialogue("eu precisava desse banho")
		dialogue_text.showDialogue()
		await get_tree().create_timer(3.5).timeout
		quest_control.finishQuest()

func change_enviroment():
	world_environment.background_energy_multiplier = 0.5
	world_environment.volumetric_fog_enabled = true

func teleport_player():
	player.global_position = position_target.get_global_transform().origin
	player.set_rotation_degrees(Vector3(0, 90, 0))
