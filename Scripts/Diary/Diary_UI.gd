extends Control

@onready var next_button = $Diary/next_button
@onready var previous_button = $Diary/previous_button
@onready var papers = $Diary/Papers
@onready var pages = $Diary/Pages
var page_count = 0
var paper_count = 0
var toggle = 0   # page == 0   paper == 1
var total_pages = 1
var total_papers = 1

func _ready():
	pass

func _on_next_button_pressed():
	if toggle == 0:
		next_page()
	else:
		next_paper()

func _on_previous_button_pressed():
	if toggle == 0:
		previous_page()
	else:
		previous_paper()

func _on_papers_button_pressed():
	toggle = 1
	pages.set_visibility(false)
	papers.set_visibility(true)


func _on_diary_button_pressed():
	toggle = 0
	papers.set_visibility(false)
	pages.set_visibility(true)

func next_page():
	if page_count >= total_pages:
		return
	
	page_count += 1
	pages.change_page(page_count)

func previous_page():
	if page_count == 0:
		return
	
	page_count -= 1
	pages.change_page(page_count)

func next_paper():
	if paper_count >= total_papers:
		return
	
	paper_count += 1
	papers.change_papers(paper_count)

func previous_paper():
	if paper_count == 0:
		return
	
	paper_count -= 1
	papers.change_papers(paper_count)

func reset_diary():
	_on_diary_button_pressed()
	page_count = 0
	paper_count = 0
	papers.change_papers(0)
	pages.change_page(0)

