extends Control

@onready var tutorial_text = $"../TutorialText/TutorialText"

@onready var quest_text = $QuestText
@onready var quest_text_animation = $QuestTextAnimation

@export var questActive = 0

var questsText = ["Arrume o Gerador", "Limpe a Casa", "Chame o Bob", "Coma algo", "Vá dormir"]
# 0 - Arrume o Gerador
# 1 - Limpe a Casa
# 2 - Chame o Bob
# 3 - Coma algo
# 4 - Vá dormir

# Começar tasks instantaneamente para testes
func _ready():
	tutorial_text.text = "[F] Lanterna"
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

