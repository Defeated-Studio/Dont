extends Control

@onready var tutorial_text = $"../TutorialText/TutorialText"

@onready var quest_text = $QuestText
@onready var quest_text_animation = $QuestTextAnimation

@export var questActive = 0

var questsText = ["Fix Generator", "Clean the House"]

# Começar tasks instantaneamente para testes
func _ready():
	tutorial_text.text = "[F] Flashlight"
	tutorial_text.show()
	await get_tree().create_timer(5).timeout
	tutorial_text.hide()
	startQuest()
	
func finishQuest():
	quest_text_animation.play_backwards("show")
	questActive += 1
		
func startQuest():
	quest_text.text = questsText[questActive]
	quest_text_animation.play("show")

