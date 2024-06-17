extends Control

signal QuestStarted

@onready var quest_text = $QuestText
@onready var quest_text_animation = $QuestTextAnimation

static var questActive = 0

var questsText = ["Arrume o Gerador", "Chame o Bob", "Coma algo", "Vá dormir", "Investigue o barulho", "Limpe a Casa"]
# 0 - Arrume o Gerador
# 1 - Chame o Bob
# 2 - Coma algo
# 3 - Vá dormir
# 4 - Investigue o barulho
# 5 - Limpe a Casa


# Começar tasks instantaneamente para testes
func _ready():
	pass
	
func finishQuest():
	quest_text_animation.play_backwards("show")
	questActive += 1
	QuestStarted.emit()

func startQuest():
	if questActive == -1:
		questActive = 0
	quest_text.text = questsText[questActive]
	quest_text_animation.play("show")
	

