extends Control

@onready var gameText = $gameText
@onready var timerText = $Timer
var text_queue = []
var textAvailable = true
var showNext = false

# Called when the node enters the scene tree for the first time.
func _ready():
	gameText.hide()
	queue_text("This house is not what i expected")
	queue_text("They told me it was gonna be empty")
	queue_text("I can't believe i'm gonna have to stay here for the next 3 months")
	queue_text("Maybe i should go to sleep")
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
