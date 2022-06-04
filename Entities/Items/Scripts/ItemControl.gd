extends Node2D

onready var item_data = preload("res://Scripts/ItemsData.gd").new().items_data.get(str((randi()%5)))

func _ready():
	$TextureRect.texture = item_data.texture
	$AnimationPlayer.play("arise")

func take():
	get_tree().queue_delete(self)
	return item_data
