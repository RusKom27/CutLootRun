extends Node2D


var items_data = load("res://Scripts/ItemsData.gd").new().items_data

var item_data = items_data.get("0")


func _ready():
	$AnimationPlayer.play("arise")


func set_item_data(var i):
	item_data = items_data.get(i%len(items_data))
	$TextureRect.texture = item_data.texture
	return item_data

func take():
	get_tree().queue_delete(self)
	return item_data
