extends Control

@onready var mom = $Mom
@onready var bob = $Bob
@onready var messages = $Messages

@onready var second_date = $"Bob/ScrollContainer/VBoxContainer/SecondDate"
@onready var space_25 = $"Bob/ScrollContainer/VBoxContainer/Space25"
@onready var message_23 = $"Bob/ScrollContainer/VBoxContainer/Message23"
@onready var space_23 = $"Bob/ScrollContainer/VBoxContainer/Space23"
@onready var space_24 = $"Bob/ScrollContainer/VBoxContainer/Space24"
@onready var message_24 = $"Bob/ScrollContainer/VBoxContainer/Message24"
@onready var space_28 = $"Bob/ScrollContainer/VBoxContainer/Space28"
@onready var no_signal = $"Bob/ScrollContainer/VBoxContainer/Message23/noSignal"
@onready var no_signal_2 = $"Bob/ScrollContainer/VBoxContainer/noSignal2"
@onready var space_27 = $"Bob/ScrollContainer/VBoxContainer/Space27"

@onready var scrollbar = $"Bob/ScrollContainer".get_v_scroll_bar()
@onready var scrollbarValue = $"Bob/ScrollContainer"
var max_scroll_length = 0 
var finishedTexting = false

var inBobWindow = false
var backButtonSignal = false

func _process(delta):
	if max_scroll_length != scrollbar.max_value: 
		max_scroll_length = scrollbar.max_value
		scrollbarValue.scroll_vertical = max_scroll_length

func sendBobMessages():
	await get_tree().create_timer(1.2).timeout
	second_date.show()
	space_25.show()
	message_23.show()
	space_23.show()
	await get_tree().create_timer(1.2).timeout
	no_signal.show()
	space_24.show()
	await get_tree().create_timer(2).timeout
	message_24.show()
	space_28.show()
	await get_tree().create_timer(1.2).timeout
	no_signal_2.show()
	space_27.show()
	finishedTexting = true


func showMobile():
	messages.show()
	mom.hide()
	bob.hide()

func _on_mom_button_pressed():
	mom.show()
	messages.hide()


func _on_bob_button_pressed():
	bob.show()
	messages.hide()
	inBobWindow = true


func _on_back_button_mom_pressed():
	messages.show()
	mom.hide()
	bob.hide()
	inBobWindow = false


func _on_back_button_pressed():
	backButtonSignal = true
