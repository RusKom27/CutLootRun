extends Label


func set_stat(var stat):
	if stat < 0:
		modulate = Color("#ec4c4c")
	else:
		modulate = Color("#5cec4c")
	text = str(stat)
	$AnimationPlayer.play("idle")
	


func _on_AnimationPlayer_animation_finished(_anim_name):
	get_tree().queue_delete(self)
