extends StaticBody3D

@onready var Toilet = $Object_3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func cleanToilet():
	Toilet.get_active_material(0).albedo_color = Color(0.05, 0.14, 0.41, 1)
