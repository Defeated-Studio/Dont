extends CanvasLayer

@onready var animation = $"Night1-2/AnimationPlayer"

func change_scene(target_scene, anim, scene_change=1):
	if anim == "night1-2":
		animation.play("dissolve_night1-2")
		await animation.animation_finished
		if scene_change:
			get_tree().change_scene_to_file(target_scene)
		animation.play_backwards('dissolve')
	elif anim == "night2-day2":
		animation.play("dissolve_night2-day2")
		await animation.animation_finished
		if scene_change:
			get_tree().change_scene_to_file(target_scene)
		animation.play_backwards('dissolve')
