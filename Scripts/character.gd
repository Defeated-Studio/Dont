extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const CROUCH_SPEED = 2.0
const SPRINT_SPEED = 8.0
var crouched = false
var finishedAnimation = true
@export var sensitivity = 2
@onready var animation = $AnimationPlayer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Backwards")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	
	var current_speed = SPEED
	if Input.is_action_pressed("Crouch"):
		current_speed = CROUCH_SPEED
		if !crouched and finishedAnimation:
			finishedAnimation = false
			animation.play("Crouch")
			crouched = true
	else:
		if crouched and finishedAnimation:
			finishedAnimation = false
			animation.play("Uncrouch")
			crouched = false
	
	
	if Input.is_action_pressed("Sprint") and !crouched:
		current_speed = SPRINT_SPEED
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	
	move_and_slide()


func _input(event):
	if (event is InputEventMouseMotion):
		rotation.y -= event.relative.x / 1000 * sensitivity
		$Camera3D.rotation.x -= event.relative.y / 1000 * sensitivity
		rotation.x = clamp(rotation.x, PI/-2, PI/2)
		$Camera3D.rotation.x = clamp($Camera3D.rotation.x, -2, 2)

func _on_animation_player_animation_finished(anim_name):
	finishedAnimation = true

