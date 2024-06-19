extends Control

@onready var left_page = $left_page
@onready var right_page = $right_page

var page = 0
var page_texts := ["Cheguei aqui e logo percebi que essa casa não é nada como nas fotos. Talvez ela fosse daquele jeito antes, mas agora parece tão velha. Mas tudo bem, eu que resolvi vir pra cá, precisava de mudanças na minha vida mesmo.
Ainda bem que eu trouxe esse diário aqui comigo, sem sinal de internet e a TV fora do ar realmente fica sem muito o que fazer. Pelo menos com isso eu posso passar um pouco do tempo, e também não me sinto tão solitário. Vou mostrar esse diário pra minha mãe quando ela vier visitar pra ela ver como eu tô vivendo de boa sozinho.
Mas sinceramente, tem umas coisas que me deixaram meio desconfiado com esse lugar. Tudo bem não ter sinal de internet ainda e tal, recém me mudei pra cá, essas coisas acontecem, mas e aquele papel que eu achei ontem? Quem é essa tal de Helena e o que foi isso que ela tava dizendo? Ainda tô sem sinal, não vou conseguir falar com o Bob sobre isso.
Talvez ela só estivesse vendo coisas mesmo. Ontem eu estava bem cansado e estava um pouco assim também, mas era só o cansaço. Até esqueci de fechar a porta direito.", "É bom que esse gerador pare logo de se desligar, fica muito escuro aqui de noite, preciso da luz se não não enxergo um palmo na minha frente. Ainda bem que trouxe minha lanterna.
Hoje vou ter que começar dando um jeito na bagunça que essa casa tá. Impossível viver num lugar assim por muito tempo, vou terminar de escrever aqui e vou dar uma geral em tudo.", "2/1", "2/2", "3/1", "3/2", "4/1", "4/2"]

func _ready():
	set_visibility(true)

func toggle_visibility():
	set_visibility(not visible)

func set_visibility(is_visible: bool):
	visible = is_visible

func change_page(to_page: int):
	if to_page == page:
		return
	
	page = to_page
	left_page.text = page_texts[to_page*2]
	right_page.text = page_texts[(to_page*2) + 1]
