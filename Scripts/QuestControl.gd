extends Control

signal QuestStarted

@onready var quest_text = $QuestText
@onready var quest_text_animation = $QuestTextAnimation

static var questActive = -1

var questsText = ["Arrume o Gerador", "Chame o Bob", "Limpe a Casa", "Coma algo", "Vá dormir", "Investigue o barulho"]
# 0 - Arrume o Gerador
# 1 - Chame o Bob
# 2 - Limpe a Casa
# 3 - Coma algo
# 4 - Vá dormir
# 5 - Investigue o barulho

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
	

