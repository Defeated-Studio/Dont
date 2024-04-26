extends Control

@onready var quest_text = $QuestText

var questsText = ["Fix Generator", "Clean the House"]
var questsCompleted = 0

func finishQuest():
	questsCompleted += 1
		
func startQuest():
	quest_text.text = questsText[questsCompleted-1]
	
func _on_area_3d_body_entered(body):
	startQuest()
