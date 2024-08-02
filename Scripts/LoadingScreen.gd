extends Control

var next_scene: String
@onready var progress_bar = $ProgressBar
@onready var logo_bar = $LogoBar
@onready var dont_bar = $DontBar
@onready var label = $Label2

func _ready():
	next_scene = SaverLoader.next_scene
	ResourceLoader.load_threaded_request(next_scene)

func _process(delta):
	var progress = []
	ResourceLoader.load_threaded_get_status(next_scene, progress)
	
	logo_bar.value = progress[0]*100
	label.text = str(round(progress[0]*100)) + "%"
	
	if progress[0] == 1:
		var packed_scene = ResourceLoader.load_threaded_get(next_scene)
		get_tree().change_scene_to_packed(packed_scene)
