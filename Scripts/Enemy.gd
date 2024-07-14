extends CharacterBody3D

@onready var player = %Player
@onready var nav : NavigationAgent3D = $NavigationAgent3D
@onready var animation_player = $AnimationPlayer

var following = false

var speed = 2.5
var accel = 10

func _physics_process(delta):
	if following:
		if speed == 2.5:
			animation_player.speed_scale = 1
		else:
			animation_player.speed_scale = 1.5
		
		animation_player.play("walk")
		var direction = Vector3()
		
		nav.target_position = player.global_position
		direction = nav.get_next_path_position() - self.global_position
		direction = direction.normalized()
			
		
		velocity = velocity.lerp(direction * speed, accel*delta)
		look_at(global_transform.origin + velocity)
		move_and_slide()
		self.global_position.y -= 0.1
	else:
		animation_player.play("idle")

