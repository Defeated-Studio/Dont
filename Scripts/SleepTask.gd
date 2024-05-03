extends Node3D
var canSleep = false
@onready var interact_text = %InteractText
@onready var quest_control = $"../QuestControl"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("interact") and canSleep:
		print("Dia acabou")


func _on_bed_area_body_entered(body):
	if quest_control.questActive == 2:
		canSleep = true
		interact_text.show()
		interact_text.text = "[E] Dormir"

func _on_bed_area_body_exited(body):
	canSleep = false
	interact_text.hide()
