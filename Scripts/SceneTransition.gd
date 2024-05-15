extends CanvasLayer

func change_scene(target_scene, animation):
	if animation == "Night1-2":
		$AnimationPlayer.play("dissolve_night1-2")
		await $AnimationPlayer.animation_finished
		get_tree().change_scene_to_file(target_scene)
		$AnimationPlayer.play_backwards("dissolve")
