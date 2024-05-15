extends Control


@onready var quest_text = $QuestText
@onready var quest_text_animation = $QuestTextAnimation

static var questActive = 0

var questsText = ["Arrume o Gerador", "Limpe a Casa", "Chame o Bob", "Coma algo", "Vá dormir"]
# 0 - Arrume o Gerador
# 1 - Limpe a Casa
# 2 - Chame o Bob
# 3 - Coma algo
# 4 - Vá dormir

# Começar tasks instantaneamente para testes
func _ready():
	if get_tree().get_current_scene().get_name() == "Night1":
		$"../TutorialText/TutorialText".text = "[F] Lanterna"
		$"../TutorialText/TutorialText".show()
		await get_tree().create_timer(5).timeout
		$"../TutorialText/TutorialText".hide()
		startQuest()
	
func finishQuest():
	quest_text_animation.play_backwards("show")
	questActive += 1


func startQuest():
	quest_text.text = questsText[questActive]
	quest_text_animation.play("show")

