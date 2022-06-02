extends Node2D

enum PanelComponent {
	Skills,
	Options,
	Inventory,
	Levels
}

onready var tree = get_tree()
onready var canvas = tree.root.get_node("Root/CanvasLayer");
onready var gameUI = canvas.get_child(0)
onready var menu = canvas.get_child(1)
onready var panel = menu.get_child(0)


func _ready():
	tree.paused = true
	changePauseState()

func changePauseState():
	tree.paused = !tree.paused
	menu.visible = tree.paused
	gameUI.visible = !tree.paused
	switch_panel_components(PanelComponent.Levels)


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		changePauseState()

func _on_PauseButton_button_down():
	changePauseState()


func _on_ContinueButton_button_down():
	changePauseState()


func _on_ExitButton_button_down():
	tree.change_scene("res://Scenes/StartMenu.tscn")


func switch_panel_components(needed_component: int):
	for i in range(panel.get_child_count()):
		if i == needed_component:
			panel.get_child(i).visible = true
		else:
			panel.get_child(i).visible = false
		


func _on_SkillSButton_button_down():
	switch_panel_components(PanelComponent.Skills)


func _on_OptionsButton_button_down():
	switch_panel_components(PanelComponent.Options)


func _on_InventoryButton_button_down():
	switch_panel_components(PanelComponent.Inventory)


func _on_SaveButton_button_down():
	pass # Replace with function body.
