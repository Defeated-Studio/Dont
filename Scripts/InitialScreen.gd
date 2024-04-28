extends Node2D

@onready var initial_screen = $"."
@onready var animation_player = $Control/AnimationPlayer
@onready var label = $Control/Label
@onready var label_2 = $Control/Label2
@onready var label_3 = $Control/Label3
var anim_next = 0
var flag = 0

func _ready():
	animation_player.play("fade_in_first")
	animation_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name):
	if anim_name == "fade_out_first":
		anim_next += 1
		if anim_next == 1:
			_change_labels()
			animation_player.play("fade_in_first")
		elif anim_next == 2:
			animation_player.play("fade_in_sec")
	elif anim_name == "fade_out_screen":
		_load_main_game()
	
	flag = 1

func _change_labels():
	label.text = "Após quase não encontrar viagens de ônibus disponíveis para o lugar e enfrentar uma exaustiva viagem, Jake se depara com algo que fora lhe dito no momento da compra."
	label_2.text = "A casa se encontrava no meio da floresta, separada da pequena cidade por uma longa camada de árvores, com apenas uma trilha o levando ao local."
	label_3.text = "Trilha essa, que ele teve que percorrer andando pela maior parte, chegando já durante a noite na casa"

func _process(delta):
	if Input.is_key_pressed(KEY_SPACE) && flag == 1:
		flag = 0
		if anim_next == 0 || anim_next == 1:
			animation_player.play("fade_out_first")
		elif anim_next == 2:
			animation_player.play("fade_out_screen")

func _load_main_game():
	var pscene = load("res://Scenes/Night1.tscn")
	get_tree().change_scene_to_packed(pscene)
