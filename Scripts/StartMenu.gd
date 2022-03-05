extends Node2D


func _on_ContinueButton_button_down():
	print(load("res://Scenes/Main.tscn"))
	get_tree().change_scene("res://Scenes/Main.tscn")
	
