extends Node2D

onready var tree = get_tree()
onready var menu = tree.root.get_node("Root/CanvasLayer/Menu");
onready var gameUI = tree.root.get_node("Root/CanvasLayer/GameUI");

func _ready():
	tree.paused = false

func changePauseState():
	tree.paused = !tree.paused
	menu.visible = tree.paused
	gameUI.visible = !tree.paused

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		changePauseState()

func _on_PauseButton_button_down():
	changePauseState()


func _on_ContinueButton_button_down():
	changePauseState()



func _on_ExitButton_button_down():
	tree.change_scene("res://Scenes/StartMenu.tscn")
