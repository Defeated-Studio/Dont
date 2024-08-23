extends Control

@onready var left_paper = $left_paper
@onready var left_paper_text = $left_paper/left_paper_text
@onready var right_paper_text = $right_paper/right_paper_text
@onready var right_paper = $right_paper
@onready var num_left = $num_left
@onready var num_right = $num_right

var paper = 0
var paper_texts = ["Não sei quem vai encontrar isso, mas preciso escrever. Talvez assim as coisas fiquem mais claras pra mim também. Me mudei pra essa casa há algum tempo.\nSinto que estou sendo observada o tempo todo. Não sei explicar, mas é como se alguém ou algo estivesse me vigiando. A cidade não gosta de falar sobre essas coisas. Fico com a sensação de que há algo escondido por aqui.\nSe você encontrou isso, fique atento. Confie no seu instinto. Como minha mãe sempre disse: nosso instinto é a alma falando o que o corpo contesta. \n- Helena", 
"Eu não estava imaginando coisas, tem algo de errado aqui, não entendi muito bem o que é, mas sei disso: \n1 - Não corra, não olhe e não grite. \n2 - Nunca fique na floresta durante a noite. \n3 - Nunca saia da trilha marcada, está marcada por uma razão. \n4 - Se você escutar vozes chamando seu nome, NÃO responda. \n5 - Nunca olhe diretamente para as árvores.", 
"Essas criaturas nas florestas, eu juro que são reais, eu não estou ficando louca.\nElas são como sombras vivas, quase impossíveis de enxergar. Quando mudam assumem a forma de pessoas ou animais, tentando nos enganar.\nÉ muito importante que você reconheça e se mantenha longe.", 
"SE ESCONDA", "Quando o medo alcançar seu ápice e a mente estiver tomada pelo terror absoluto, com a alma totalmente exposta, ele poderá consumi-la, saciando sua insaciável fome de pavor."]


func _ready():
	set_visibility(false)
	if paper == 0:
		right_paper.visible = false


func toggle_visibility():
	set_visibility(not visible)


func set_visibility(is_visible: bool):
	visible = is_visible


func change_papers(to_paper, papers_taken):
	paper = to_paper
	if paper == 2:
		num_left.text = "5"
		num_right.text = " "
		right_paper.visible = false;
		if papers_taken[paper*2]:
			left_paper.visible = true;
			left_paper_text.text = paper_texts[paper*2];
		else:
			left_paper.visible = false;
		return;
	
	num_left.text = str((paper*2)+1)
	num_right.text = str((paper*2)+2)
	
	if paper == 1:
		var font = load("res://Fonts/BadScript-Regular.ttf")
		right_paper_text.add_theme_font_override("font", font)
	else:
		var font = load("res://Fonts/Allura-Regular.ttf")
		right_paper_text.add_theme_font_override("font", font)
	
	if papers_taken[paper*2]:
		left_paper.visible = true;
		left_paper_text.text = paper_texts[to_paper*2];
	else:
		left_paper.visible = false;
	
	if papers_taken[(paper*2) + 1]:
		right_paper.visible = true
		right_paper_text.text = paper_texts[(to_paper*2) + 1];
	else:
		right_paper.visible = false;


func start_papers(papers_taken):
	num_left.text = str(1)
	num_right.text = str(2)
	if papers_taken[0] == 1:
		left_paper.visible = true;
		left_paper_text.text = paper_texts[0];
	else:
		left_paper.visible = false;
	
	if papers_taken[1] == 1:
		right_paper.visible = true;
		right_paper_text.text = paper_texts[1];
	else:
		right_paper.visible = false;
