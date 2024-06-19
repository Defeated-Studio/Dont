extends CharacterBody3D

var ground = "Grass"
@onready var wood_foot_steps = $Feet/WoodFootSteps
@onready var grass_foot_steps = $Feet/GrassFootSteps
@onready var grass_foot_steps_run = $Feet/GrassFootStepsRun
@onready var wood_foot_steps_run = $Feet/WoodFootStepsRun
@onready var flash_light_sound = $Head/FlashlightModel/FlashLightSound

var canMove = true
var canMoveCamera = true
var canUseFlashlight = true

var speed
var gravity = 9.8
const WALK_SPEED = 2.2
const SPRINT_SPEED = 5
const SENSITIVITY = 0.2

#bob variables
const BOB_FREQ = 5
const BOB_AMP = 0.02
var t_bob = 0.0

#fov variables
const BASE_FOV = 60.0
const FOV_CHANGE = 1.5

#crouch variables
var canCrouch = true
var crouched = false
var finishedCrouchAnimation = true
const CROUCH_SPEED = 1.5

var finishedFlashlightAnimation = false

var direction = Vector3.ZERO
@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var crouch_animation = $CrouchAnimation
@onready var hand = $Hand
@onready var flashlight = $Head/Flashlight
@onready var flashlight_animation = $FlashlightAnimation
@onready var flashlight_model = $Head/FlashlightModel


func change_input_flags(value):
	canMove = value
	canMoveCamera = value
	canUseFlashlight = value

func _ready():
	flashlight_model.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion and canMoveCamera:
		rotate_y(deg_to_rad(-event.relative.x*SENSITIVITY))
		head.rotate_x(deg_to_rad(-event.relative.y*SENSITIVITY))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-80), deg_to_rad(60))

func _physics_process(delta):
	if Input.is_action_just_pressed("flashlight") and canUseFlashlight:
		if flashlight.visible:
			flashlight_animation.play(("hide"))
			flashlight.hide()
			flash_light_sound.play()
		else:
			flashlight_model.show()
			flashlight.show()
			flashlight_animation.play(("show"))
			flash_light_sound.play()

	make_flashlight_follow(delta)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	if !canMove:
		speed = 0
	else:
		if crouched:
			speed = CROUCH_SPEED
		else:
			speed = WALK_SPEED
	
		if Input.is_action_pressed("sprint") and !crouched:
			speed = SPRINT_SPEED
		
	if Input.is_action_pressed("crouch") and canCrouch:
		if !crouched and finishedCrouchAnimation:
			finishedCrouchAnimation = false
			crouched = true
			crouch_animation.play("Crouch")
	else:
		if crouched and finishedCrouchAnimation:
			finishedCrouchAnimation = false
			crouch_animation.play("Uncrouch")
			crouched = false

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("a", "d", "w", "s")
	
	if (ground == "Wood"):
		if (input_dir != Vector2.ZERO) and (!wood_foot_steps.playing) and (speed != SPRINT_SPEED):
			grass_foot_steps.stop()
			grass_foot_steps_run.stop()
			
			wood_foot_steps_run.stop()
			wood_foot_steps.play()
			
		elif (input_dir != Vector2.ZERO) and (!wood_foot_steps_run.playing) and (speed == SPRINT_SPEED):
			grass_foot_steps.stop()
			grass_foot_steps_run.stop()
			
			wood_foot_steps.stop()
			wood_foot_steps_run.play()
			
		elif (input_dir == Vector2.ZERO) and ((wood_foot_steps.playing) or (wood_foot_steps_run.playing)):
			wood_foot_steps.stop()
			wood_foot_steps_run.stop()
			
	elif (ground == "Grass"):
		if (input_dir != Vector2.ZERO) and (!grass_foot_steps.playing) and (speed != SPRINT_SPEED):
			wood_foot_steps.stop()
			wood_foot_steps_run.stop()
			
			grass_foot_steps_run.stop()
			grass_foot_steps.play()
			
		elif (input_dir != Vector2.ZERO) and (!grass_foot_steps_run.playing) and (speed == SPRINT_SPEED):
			wood_foot_steps.stop()
			wood_foot_steps_run.stop()
			
			grass_foot_steps.stop()
			grass_foot_steps_run.play()
			
		elif (input_dir == Vector2.ZERO) and ((grass_foot_steps.playing) or (grass_foot_steps_run.playing)):
			grass_foot_steps.stop()
			grass_foot_steps_run.stop()
	
		
	direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta * speed)

	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	# Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	move_and_slide()


func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos

func _on_crouch_animation_animation_finished(anim_name):
	finishedCrouchAnimation = true
	
func make_flashlight_follow(delta):
	hand.rotation.y = head.rotation.y
	hand.rotation.x = head.rotation.x
