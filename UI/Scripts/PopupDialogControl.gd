extends Control


func _ready():
	$AnimationPlayer.play("hide")



func _on_Player_item_collide(var item):
	$AnimationPlayer.play("show")
	set_position(item.position)
	$Label.text = item.item_data.name + "\n[E]Take"
	


func _on_Player_item_out_collide(var item):
	$AnimationPlayer.play("hide")
