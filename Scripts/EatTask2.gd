extends Node3D
@onready var quest_control = $"../QuestControl"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_quest_control_quest_started():
	if quest_control.questActive == 7:
		quest_control.startQuest()
