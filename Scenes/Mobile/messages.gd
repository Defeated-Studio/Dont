extends Control

@onready var mom = $Mom
@onready var bob = $Bob
@onready var messages = $Messages

@onready var first_date = $Bob/ScrollContainer/VBoxContainer/FirstDate
@onready var second_date = $"Bob/ScrollContainer/VBoxContainer/SecondDate"
@onready var first_date_mom = $Mom/ScrollContainer/VBoxContainer/FirstDate


@onready var space_25 = $"Bob/ScrollContainer/VBoxContainer/Space25"
@onready var message_23 = $"Bob/ScrollContainer/VBoxContainer/Message23"
@onready var space_23 = $"Bob/ScrollContainer/VBoxContainer/Space23"
@onready var space_24 = $"Bob/ScrollContainer/VBoxContainer/Space24"
@onready var message_24 = $"Bob/ScrollContainer/VBoxContainer/Message24"
@onready var space_28 = $"Bob/ScrollContainer/VBoxContainer/Space28"
@onready var no_signal = $"Bob/ScrollContainer/VBoxContainer/Message23/noSignal"
@onready var no_signal_2 = $"Bob/ScrollContainer/VBoxContainer/noSignal2"
@onready var space_27 = $"Bob/ScrollContainer/VBoxContainer/Space27"

@onready var bob_scrollbar = $"Bob/ScrollContainer".get_v_scroll_bar()
@onready var bob_scrollbarValue = $"Bob/ScrollContainer"

@onready var mom_scrollbar = $Mom/ScrollContainer.get_v_scroll_bar()
@onready var mom_scrollbarValue = $Mom/ScrollContainer

@onready var first_date_2 = $Mom/ScrollContainer/VBoxContainer/FirstDate2
@onready var space_15 = $Mom/ScrollContainer/VBoxContainer/Space15
@onready var ninth_message_2 = $Mom/ScrollContainer/VBoxContainer/NinthMessage2
@onready var no_signal_mom = $Mom/ScrollContainer/VBoxContainer/NinthMessage2/noSignal
@onready var space_16 = $Mom/ScrollContainer/VBoxContainer/Space16
@onready var space_18 = $Mom/ScrollContainer/VBoxContainer/Space18
@onready var sixteenth_message_2 = $Mom/ScrollContainer/VBoxContainer/SixteenthMessage2
@onready var space_19 = $Mom/ScrollContainer/VBoxContainer/Space19
@onready var eleventh_message_3 = $Mom/ScrollContainer/VBoxContainer/EleventhMessage3
@onready var space_20 = $Mom/ScrollContainer/VBoxContainer/Space20
@onready var texture_rect = $Mom/ScrollContainer/VBoxContainer/NinthMessage2/TextureRect




var max_scroll_length_bob = 0 
var max_scroll_length_mom = 0

var finishedTexting = false

var inBobWindow = false
var triggerMomTask = false
var backButtonSignal = false

func _process(delta):
	if max_scroll_length_bob != bob_scrollbar.max_value: 
		max_scroll_length_bob = bob_scrollbar.max_value
		bob_scrollbarValue.scroll_vertical = max_scroll_length_bob
	if max_scroll_length_mom != mom_scrollbar.max_value: 
		max_scroll_length_mom = mom_scrollbar.max_value
		mom_scrollbarValue.scroll_vertical = max_scroll_length_mom

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
	triggerMomTask = true


func _on_bob_button_pressed():
	bob.show()
	messages.hide()
	inBobWindow = true


func _on_back_button_mom_pressed():
	messages.show()
	mom.hide()
	bob.hide()
	inBobWindow = false
	triggerMomTask = false


func _on_back_button_pressed():
	backButtonSignal = true

func updateMessages():
	no_signal.hide()
	no_signal_2.hide()
	no_signal_mom.hide()
	
	first_date_2.show()
	space_15.show()
	ninth_message_2.show()
	space_16.show()
	space_18.show()
	sixteenth_message_2.show()
	space_19.show()
	eleventh_message_3.show()
	texture_rect.show()
	
