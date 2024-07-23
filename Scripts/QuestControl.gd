extends Control

signal QuestStarted

@onready var quest_text = $QuestText
@onready var quest_text_animation = $QuestTextAnimation

static var questActive = 14

var questsText = ["Arrume o Gerador e Ache a chave", "Chame o Bob", "Coma algo", "Vá dormir", 
"Investigue o barulho", "Escreva no Diário", "Limpe a Casa", "Passar o tempo", "Coma algo",
"Vá dormir", "Ache sinal", "Va dormir", "Atender a porta", "Dormir", "Pegar Papel", "SE ESCONDA", "Tentar Dormir",
"Formar Barricada"]
# 0  - Arrume o Gerador e Ache a chave
# 1  - Chame o Bob
# 2  - Coma algo
# 3  - Vá dormir
# 4  - Investigue o barulho
# 5  - Escreva no Diário
# 6  - Limpe a Casa
# 7  - Passar o Tempo
# 8  - Coma algo
# 9  - Vá dormir
# 10 - Ache sinal
# 11 - Dormir
# 12 - Atender a porta
# 13 - Dormir
# 14 - Pegar Papel
# 15 - SE ESCONDA
# 16 - Tentar Dormir
# 17 - Formar Barricada

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
	

