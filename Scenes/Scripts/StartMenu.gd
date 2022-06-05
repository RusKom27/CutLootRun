extends Node2D

onready var Root = get_parent()

func _on_ContinueButton_button_down():
	Root.start_game(false)
	

func _on_NewGameButton_button_down():
	Root.start_game(true)
