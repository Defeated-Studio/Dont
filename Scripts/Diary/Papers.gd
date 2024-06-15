extends Control

@onready var left_paper_text = $left_paper/left_paper_text
@onready var right_paper_text = $right_paper/right_paper_text
@onready var right_paper = $right_paper

var paper = 0
var paper_texts := ["Paper 1", "Paper 2", "Paper 3", "Paper 4"]

func _ready():
	set_visibility(false)
	if paper == 0:
		right_paper.visible = false

func toggle_visibility():
	set_visibility(not visible)

func set_visibility(is_visible: bool):
	visible = is_visible

func change_papers(to_paper: int):
	if paper == to_paper:
		return
	
	paper = to_paper
	left_paper_text.text = paper_texts[to_paper*2]
	right_paper_text.text = paper_texts[(to_paper*2) + 1]
