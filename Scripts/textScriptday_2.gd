extends Control

@onready var gameText = $gameText
@onready var timerText = $Timer
var text_queue = []
var textAvailable = true
var showNext = false

# Called when the node enters the scene tree for the first time.
func _ready():
	queue_text(" ")
	queue_text("WHAT?")
	queue_text("")
	show_text()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ((Input.is_action_just_pressed("nextText") and textAvailable) 
	or (showNext and textAvailable)) and !timerText.is_stopped():
		gameText.show()
		show_text()
		showNext = false


func queue_text(text):
	text_queue.push_back(text)

func show_text():
	gameText.text = text_queue.pop_front()
	if gameText.text == "":
		textAvailable = false


func _on_timer_timeout():
	showNext = true
