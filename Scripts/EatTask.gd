extends Node3D

@onready var interact_text = %InteractText
@onready var quest_control = $"../QuestControl"
@onready var dialogue_text = $"../Player/DialogueText"
@onready var get_food_col = $GetFood/GetFoodCol
@onready var ray_cast_kitchen_col = $GetFood/RayCastKitchen/RayCastKitchenCol
@onready var can_food = $"../Player/Head/CanFood"
@onready var can_food_opened = $"../Player/Head/CanFood/RootNode/canBody/topOpen"
@onready var can_food_closed = $"../Player/Head/CanFood/RootNode/canBody/topClosed"
@onready var interact_ray = $"../Player/Head/InteractRay"
@onready var EatAnimation = $"../Player/Head/CanFood/CanFoodAnimation"
@onready var microwave_col = $Microwave/MicrowaveCol
@onready var ray_cast_microwave_col = $Microwave/MicrowaveRaycast/CollisionShape3D
@onready var microwave_light = $"../House/MicrowaveLight"
@onready var tv_col = $TvArea/TvCol
@onready var video_mesh = $"../House/LivingRoom/TV/VideoMesh"
@onready var video = $"../House/LivingRoom/TV/SubViewport/SubViewportContainer/VideoStreamPlayer"
@onready var viewport = $"../House/LivingRoom/TV/SubViewport"
@onready var tv_audio = $"../House/LivingRoom/TV/TvSound"
@onready var sofa_col = $SofaArea/SofaCol
@onready var ray_cast_sofa_col = $SofaArea/RayCastSofa/CollisionShape3D
@onready var pos = $"../House/Position3D"
@onready var player = $"../Player"
@onready var player_view = $"../Player/Head"
@onready var BedroomDoor = $"../House/Bedroom1/Bedroom1Door"
@onready var trash_col = $TrashArea/TrashCol
@onready var ray_cast_trash_col = $TrashArea/TrashRayCast/CollisionShape3D
@onready var world = $".."

@onready var skin_walker = $"../../../SkinWalker"
@onready var skin_walker_anim = $"../../../SkinWalker/AnimationPlayer"

@onready var microwave_sound = $Microwavesound


var canPickup = false
var canMicrowave = false
var MicrowaveDone = false
var canTurnTv = false
var TvOn = false
var canSitDown = false
var sitDown = false
var doneEating = false
var canThrow = false
var showTvDialogue = true
var canClickAgain = true
var canShowEnemy = false
var eatCount = 3
var playerStandupPos
var playerViewPos

# Called when the node enters the scene tree for the first time.
func _ready():
	_set_viewport_mat(video_mesh, viewport, 0)
	
func _set_viewport_mat(_display_mesh : MeshInstance3D, _sub_viewport : SubViewport, _surface_id : int = 0):
	var _mat : StandardMaterial3D = StandardMaterial3D.new()
	_mat.albedo_texture = _sub_viewport.get_texture()
	_mat.emission_enabled = true
	_mat.emission_texture = _sub_viewport.get_texture()
	_mat.emission_energy_multiplier = 10
	_display_mesh.set_surface_override_material(_surface_id, _mat)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if canShowEnemy:
		skin_walker.show()
		skin_walker.position.x += 1 * delta
		skin_walker_anim.play("walk")
		if skin_walker.position.x > 5:
			canShowEnemy = false
			skin_walker.hide()
		
	if doneEating:
		interact_text.text = "[E] Levantar"
		interact_text.show()
		if Input.is_action_just_pressed("interact"):
			interact_text.hide()
			sitDown = false
			player.canCrouch = true
			player.canMove = true
			world.canOpenMobile = true
			#world.canOpenDiary = true
			player.global_position = playerStandupPos
			player_view.position.y = playerViewPos
			doneEating = false
			trash_col.set_deferred("disabled", false)
			ray_cast_trash_col.set_deferred("disabled", false)
			
	if (Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("LeftMouseButton")) and canThrow and IsRayCasting.canInteract:
		can_food.hide()
		quest_control.finishQuest()
		get_node("TrashArea").queue_free()

	if Input.is_action_just_pressed("LeftMouseButton") and sitDown and !doneEating and canClickAgain:
		canClickAgain = false
		eatCount -= 1
		EatAnimation.play("Eating")
		interact_text.hide()
		if eatCount == 2:
			if !BedroomDoor.doorOpen:
				BedroomDoor.animation.play("OpenDoorAni")
				BedroomDoor.setdoorOpen(!BedroomDoor.doorOpen)
		if eatCount == 1:
			canShowEnemy = true
			await get_tree().create_timer(0.5).timeout
			dialogue_text.timeBetweenText = 3
			dialogue_text.queueDialogue("eu não posso simplesmente sair andando, to muito longe de casa")
			dialogue_text.showDialogue()
			await get_tree().create_timer(0.7).timeout
		await get_tree().create_timer(3).timeout
		if eatCount == 0:
			sitDown = false
			dialogue_text.timeBetweenText = 2
			dialogue_text.queueDialogue("essa comida tá uma porcaria")
			dialogue_text.queueDialogue("estou cheio")
			dialogue_text.showDialogue()
			await get_tree().create_timer(4.2).timeout
			doneEating = true
		else:
			interact_text.text = "[MB1] Comer"
			interact_text.show()
		canClickAgain = true

	if (Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("LeftMouseButton")) and canSitDown and IsRayCasting.canInteract:
		if showTvDialogue:
			dialogue_text.timeBetweenText = 2
			dialogue_text.queueDialogue("preciso ligar a tv antes")
			dialogue_text.showDialogue()
		else:
			get_node("SofaArea").queue_free()
			playerStandupPos = player.global_position
			player.global_position = pos.get_global_transform().origin
			playerViewPos = player_view.position.y
			player_view.position.y = 0.6
			player.canMove = false
			player.canCrouch = false
			world.canOpenMobile = false
			#world.canOpenDiary = false
			sitDown = true
			await get_tree().create_timer(0.5).timeout
			interact_text.text = "[MB1] Comer"
			interact_text.show()
			dialogue_text.timeBetweenText = 3
			dialogue_text.queueDialogue("não tem nenhum horário de ônibus pros próximos 5 dias")
			dialogue_text.queueDialogue("eu tive sorte de conseguir esse para vir")
			dialogue_text.showDialogue()

	if ((Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("LeftMouseButton")) 
		and canTurnTv and IsRayCasting.canInteract):
		if !TvOn:
			tv_audio.play()
			video_mesh.show()
			video.play()
			TvOn = !TvOn
			if showTvDialogue:
				await get_tree().create_timer(0.7).timeout
				dialogue_text.timeBetweenText = 3
				dialogue_text.queueDialogue("sem sinal, claro")
				dialogue_text.showDialogue()
				showTvDialogue = false
		else:
			tv_audio.stop()
			video_mesh.hide()
			video.stop()
			TvOn = !TvOn
			
	if (Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("LeftMouseButton")) and canPickup and IsRayCasting.canInteract:
		can_food.show()
		get_node("GetFood").queue_free()
		microwave_col.set_deferred("disabled", false)
		ray_cast_microwave_col.set_deferred("disabled", false)

	if (Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("LeftMouseButton")) and canMicrowave and IsRayCasting.canInteract:
		if MicrowaveDone:
			can_food.show()
			get_node("Microwave").queue_free()
			tv_col.set_deferred("disabled", false)
			sofa_col.set_deferred("disabled", false)
			ray_cast_sofa_col.set_deferred("disabled", false)
			dialogue_text.timeBetweenText = 3
			dialogue_text.queueDialogue("eu gosto de comer enquanto assisto tv")
			dialogue_text.showDialogue()
			ray_cast_microwave_col.set_deferred("disabled", true)
		else:
			can_food.hide()
			microwave_col.set_deferred("disabled", true)
			can_food_closed.hide()
			can_food_opened.show()
			microwave_light.show()
			microwave_sound.play()
			await get_tree().create_timer(9.1).timeout
			microwave_light.hide()
			MicrowaveDone = true
			microwave_col.set_deferred("disabled", false)
			# PLAY DONE SOUND


func _on_trigger_eat_task_body_entered(body):
	if quest_control.questActive == 2:
		quest_control.startQuest()
		activateCollisions()
		dialogue_text.timeBetweenText = 3
		dialogue_text.queueDialogue("estou com muita fome depois dessa viagem longa")
		dialogue_text.queueDialogue("vou comer algo enquanto penso como dar o fora daqui")
		dialogue_text.showDialogue()
		get_node("TriggerEatTask").queue_free()


func activateCollisions():
	get_food_col.set_deferred("disabled", false)
	ray_cast_kitchen_col.set_deferred("disabled", false)

func _on_get_food_body_entered(body):
	interact_text.text = "[E] Pegar"
	interact_text.show()
	canPickup = true


func _on_get_food_body_exited(body):
	interact_text.hide()
	canPickup = false


func _on_microwave_body_entered(body):
	interact_text.text = "[E] Usar"
	interact_text.show()
	canMicrowave = true


func _on_microwave_body_exited(body):
	interact_text.hide()
	canMicrowave = false


func _on_tv_area_body_entered(body):
	interact_text.text = "[E] Ligar"
	interact_text.show()
	canTurnTv = true


func _on_tv_area_body_exited(body):
	interact_text.hide()
	canTurnTv = false


func _on_sofa_area_body_entered(body):
	interact_text.text = "[E] Sentar"
	interact_text.show()
	canSitDown = true


func _on_sofa_area_body_exited(body):
	interact_text.hide()
	canSitDown = false


func _on_trash_area_body_entered(body):
	canThrow = true
	interact_text.text = "[E] Jogar fora"
	interact_text.show()


func _on_trash_area_body_exited(body):
	canThrow = false
	interact_text.hide()
