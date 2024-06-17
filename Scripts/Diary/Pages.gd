extends Control

@onready var left_page = $left_page
@onready var right_page = $right_page

var page = 0
var page_texts := ["1/1", "1/2", "2/1", "2/2", "3/1", "3/2", "4/1", "4/2"]

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
