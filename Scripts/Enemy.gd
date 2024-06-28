extends CharacterBody3D

@onready var player = %Player
@onready var nav : NavigationAgent3D = $NavigationAgent3D
@onready var animation_player = $AnimationPlayer

var following = false

var speed = 3
var accel = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if following:
		animation_player.play("walk")
		
		var direction = Vector3()
		
		nav.target_position = player.global_position
		direction = nav.get_next_path_position() - self.global_position
		direction = direction.normalized()
		
		look_at(player.global_position)
		
		velocity = velocity.lerp(direction * speed, accel*delta)
		move_and_slide()
	else:
		animation_player.play("idle")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
