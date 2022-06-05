extends Label


func _ready():
	visible = true
	
func set_event_text(var event_text):
	text = event_text
	$AnimationPlayer.play("show")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "show":
		$AnimationPlayer.play("hide")
	if anim_name == "hide":
		get_tree().queue_delete(self)
