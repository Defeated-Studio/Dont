extends SubViewportContainer
@onready var front_door = $SubViewport/World/House/FrontDoor
@onready var tutorial_text = %TutorialText
@onready var house = $SubViewport/World/House


# Called when the node enters the scene tree for the first time.
func _ready():
	
	var res = []
	findByClass(house, "OmniLight3D", res)
	for i in res:
		i.hide()
		
	tutorial_text.text = "[F] Lanterna"
	tutorial_text.show()
	await get_tree().create_timer(5).timeout
	tutorial_text.hide()
	front_door.locked = true
	

func findByClass(node: Node, className : String, result : Array):
	if node.is_class(className):
		if node.name != "MicrowaveLight":
			result.push_back(node)
		
	for child in node.get_children():
		findByClass(child, className, result)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
