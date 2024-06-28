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

var max_scroll_length_bob = 0 
var max_scroll_length_mom = 0

var finishedTexting = false

var inBobWindow = false
var triggerMomTask = false
var backButtonSignal = false
var previous_day

func _ready():
	var date = Time.get_date_dict_from_system()
	var current_day = date["day"]
	var current_month = date["month"]
	if current_day == 1:
		previous_day = 30
	else:
		previous_day = current_day - 1
	
	if current_month == 1 and current_day == 1:
		current_month = 12
		
	if current_month < 10:
		current_month = "0" + str(current_month)
		
	first_date.text = str(previous_day) + "/" + str(current_month) + " " + "21:06"
	
	if current_day < 10:
		current_day = "0" + str(current_day)
	
	second_date.text = str(current_day) + "/" + str(current_month) + " " + "23:10"
	first_date_mom.text = str(current_day) + "/" + str(current_month) + " " + "16:21"

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


func _on_back_button_pressed():
	backButtonSignal = true
