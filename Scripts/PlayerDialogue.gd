extends Control

@onready var dialogue_text = $DialogueText
@onready var dialogue_timer = $DialogueTimer

var text_queue = []

func queueDialogue(text):
	text_queue.push_back(text)

func showDialogue():
	dialogue_text.text = text_queue.pop_front()
	dialogue_text.show()
	dialogue_timer.start(3)

func _on_dialogue_timer_timeout():
	if !text_queue.is_empty():
		showDialogue()
	else:
		dialogue_text.hide()
