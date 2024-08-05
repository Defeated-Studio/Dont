extends SubViewportContainer
@onready var front_door = %House/FrontDoor
@onready var tutorial_text = %TutorialText
@onready var main_camera = $SubViewport/World/Player/Head/Camera3D
@onready var states = $States
@onready var house = %House
@onready var quest_control = $SubViewport/World/QuestControl


var flag = true

func findByClass(node: Node, className : String, result : Array):
	if node.is_class(className):
		if node.name != "MicrowaveLight":
			result.push_back(node)
		
	for child in node.get_children():
		findByClass(child, className, result)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("flashlight") and tutorial_text.visible and flag:
		flag = false
		tutorial_text.hide()

func _on_initial_screen_animation_finished():
	quest_control.reset()
	main_camera.set_current(true)
	
	front_door.locked = true
	
	var res = []
	findByClass(house, "OmniLight3D", res)
	for i in res:
		i.hide()
		
	tutorial_text.text = "[F] Lanterna"
	tutorial_text.show()
	
	await get_tree().create_timer(2).timeout
	SaverLoader.save_game(1)
