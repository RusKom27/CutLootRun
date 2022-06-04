extends Control


func _ready():
	$AnimationPlayer.play("hide")

func _on_ItemIcon_mouse_entered():
	$AnimationPlayer.play("show")

func _on_ItemIcon_mouse_exited():
	$AnimationPlayer.play("hide")
