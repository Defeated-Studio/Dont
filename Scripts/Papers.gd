extends Control

@onready var paper_left_label = $paper_left/paper_left_label
@onready var paper_right_label = $paper_right/paper_right_label
var paper = 0
var paper_texts := ["Paper 1", "Paper 2", "Paper 3", "Paper 4"]

func _ready():
	set_visibility(false)

func toggle_visibility():
	set_visibility(not visible)

func set_visibility(is_visible: bool):
	visible = is_visible

func change_papers(to_paper: int):
	if paper == to_paper:
		return
	
	paper = to_paper
	paper_left_label.text = paper_texts[to_paper*2]
	paper_right_label.text = paper_texts[(to_paper*2) + 1]
