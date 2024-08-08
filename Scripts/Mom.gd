extends CharacterBody3D

@onready var player = %Player
@onready var nav : NavigationAgent3D = $NavigationAgent3D
@onready var animation_player = $AnimationPlayer

var following = false
var speed = 1.3
var accel = 1
var previous_target
var target

func _ready():
	set_physics_process(false)
	set_physics_process(true)

func _physics_process(delta):
	if following:
		animation_player.play("walk")
		
		var direction = Vector3()
		
		if target.name == "Player":
			nav.target_position = target.global_position
		else:
			nav.target_position = target.global_position
			
		direction = nav.get_next_path_position() - self.global_position
		direction = direction.normalized()
			
		velocity = velocity.lerp(direction * speed, accel*delta)
		
		if global_transform.origin.is_equal_approx(player.global_position):
			return
			
		look_at(global_transform.origin + velocity)
		move_and_slide()
	else:
		animation_player.play("idle")
