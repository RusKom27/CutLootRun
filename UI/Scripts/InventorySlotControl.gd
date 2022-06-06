extends Control

var is_entered : bool = false

func _input(_event):
	$AnimationPlayer/Name.rect_scale = Vector2(0,0)
	$AnimationPlayer/Stats.rect_scale = Vector2(0,0)
	
func _ready():
	$AnimationPlayer.play("hide")

func _on_ItemIcon_mouse_entered():
	is_entered = true
	$AnimationPlayer.play("show")

func _on_ItemIcon_mouse_exited():
	is_entered = false	
	$AnimationPlayer.play("hide")
