extends Control

const section_time := 4.0
const line_time := 0.8
const base_speed := 50
const speed_up_multiplier := 10.0
const title_color := Color.YELLOW

var scroll_speed := base_speed
var speed_up := false

@onready var line := $CreditsContainer/Line
var started := false
var finished := false

var section
var section_next := true
var section_timer := 0.0
var line_timer := 0.0
var curr_line := 0
var lines := []

var credits = [
	[
		"Don't",
		"Defeated Studios"
	],[
		"Integrantes",
		"João Vitor Farias",
		"Graziele Fagundes",
		"Otávio Rocha"
	],
	[	"Soundtrack",
		"Junior Barboza"
	],
	[
		"Agradecimentos",
		"Rafael Torchelsen",
		"Miguel Botelho",
		"Leonardo Melo",
		"Guilherme Hepp",
		"Vivian Bueno",
		"Larissa Farias",
		"Andréia Farias",
		"Olívia Farias"
	],
	[
		"Créditos",
		"Wooden Kitchen: Mieshu",
		"Death Shader: Lazarus Overclock",
		"Dirty Car: 3D Error 404",
		"TV stand: Qu3st10n",
		"Old Vintage TV: NataN",
		"Wooden Bed: Shedmon",
		"Victorian Bed: BATRIC_18",
		"Beans: Jurgen Draws Stuff",
		"Pizza Box: Logansryche",
		"Old Couch: oisougabo",
		"Round Table And Chairs: vilsonpistori",
		"Dining table: Ravi Jangid",
		"Old Stash House: bossdeff"
	],
	[
		"Obrigado por jogar."
	]
]


func _process(delta):
	var scroll_speed = base_speed * delta
	
	if section_next:
		section_timer += delta * speed_up_multiplier if speed_up else delta
		if section_timer >= section_time:
			section_timer -= section_time
			
			if credits.size() > 0:
				started = true
				section = credits.pop_front()
				curr_line = 0
				add_line()
	
	else:
		line_timer += delta * speed_up_multiplier if speed_up else delta
		if line_timer >= line_time:
			line_timer -= line_time
			add_line()
	
	if speed_up:
		scroll_speed *= speed_up_multiplier
	
	if lines.size() > 0:
		for l in lines:
			l.position.y -= scroll_speed


func add_line():
	var new_line = line.duplicate()
	new_line.text = section.pop_front()
	lines.append(new_line)
	if curr_line == 0:
		new_line.set("theme_override_colors/font_color", title_color)
	$CreditsContainer.add_child(new_line)
	
	if section.size() > 0:
		curr_line += 1
		section_next = false
	else:
		section_next = true


func _on_timer_timeout():
	get_tree().change_scene_to_file("res://Scenes/Screens/MainMenu.tscn")
