extends ColorRect


signal fade_in_finished
signal fade_out_finished

func fade_in():
	$AnimationPlayer.play("fade_in")

func fade_out():
	$AnimationPlayer.play("fade_out")

func _on_AnimationPlayer_animation_finished(anim_name):
	if (anim_name == "fade_in"):
		emit_signal("fade_in_finished")
	else:
		emit_signal("fade_out_finished")
