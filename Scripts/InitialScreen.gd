extends Node2D
# 1242 698

#@onready var initial_screen = $"."
@onready var animation_player = $Control/AnimationPlayer
@onready var label = $Control/Label
@onready var label_2 = $Control/Label2
@onready var label_3 = $Control/Label3
@onready var timer = $Control/Timer
@onready var label_6 = $Control/Label6
var anim_next = 0
var flag = 1
var timer_flag = 1

func _ready():
	animation_player.play("fade_in_first")
	animation_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name):
	if anim_name == "fade_out_first":
		anim_next += 1
		if anim_next == 1:
			_change_labels()
			animation_player.play("fade_in_third")
		elif anim_next == 2:
			animation_player.play("fade_in_sec")
	elif anim_name == "fade_out_sec":
		label_6.text = "Carregando..."
		animation_player.play("fade_out_screen")
	elif anim_name == "fade_out_screen":
		_load_main_game()
	elif (anim_name == "fade_in_first" || anim_name == "fade_in_sec" || anim_name == "fade_in_third") && timer_flag == 1:
		timer.start()
	
	flag = 1

func _change_labels():
	label.text = "Após quase não encontrar viagens de ônibus disponíveis para o lugar e enfrentar uma exaustiva viagem, Jake se depara com algo que não fora lhe dito no momento da compra."
	label_2.text = "A casa se encontrava no meio da floresta, separada da pequena cidade por uma longa camada de árvores, com apenas uma trilha o levando ao local."
	label_3.text = "Trilha essa, que ele teve que percorrer andando pela maior parte, chegando já durante a noite na casa"

func _process(delta):
	if Input.is_anything_pressed() && flag == 1:
		flag = 0
		timer_flag = 0
		if anim_next == 0 || anim_next == 1:
			animation_player.play("fade_out_first")
			timer_flag = 1
		elif anim_next == 2:
			animation_player.play("fade_out_sec")
			timer_flag = 1

func _load_main_game():
	var pscene = load("res://Scenes/Night1.tscn")
	get_tree().change_scene_to_packed(pscene)

func _on_timer_timeout():
	if anim_next == 0 || anim_next == 1:
		animation_player.play("fade_out_first")
	elif anim_next == 2:
		label_6.text = "Carregando..."
		animation_player.play("fade_out_screen")
