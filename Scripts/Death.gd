extends Control

@onready var shader = $CanvasLayer/ColorRect
@onready var audio = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func appear():
	audio.play(0.4)
	shader.visible = true;
	get_tree().paused = true
	await get_tree().create_timer(5).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Screens/MainMenu.tscn")
	
