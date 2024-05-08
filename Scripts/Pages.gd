extends Control

@onready var page_left = $page_left
@onready var page_right = $page_right
var page = 0
var page_texts := ["Page 1/1", "Page 1/2", "Page 2/1", "Page 2/2"]

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
	page_left.text = page_texts[to_page*2]
	page_right.text = page_texts[(to_page*2) + 1]
