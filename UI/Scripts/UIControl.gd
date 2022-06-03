extends CanvasLayer

enum PanelComponent {
	Skills,
	Options,
	Inventory,
	Levels
}

enum GameUIComponent {
	XPBar,
	HealthBar,
	XPIcon,
	HealthIcon,
	PauseButton
}

onready var tree = get_tree()


func _ready():
	tree.paused = true
	changePauseState()
	

func changePauseState():
	tree.paused = !tree.paused
	$Menu.visible = tree.paused
	$GameUI.visible = !tree.paused
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
	for i in range($Menu/Panel.get_child_count()):
		if i == needed_component:
			$Menu/Panel.get_child(i).visible = true
		else:
			$Menu/Panel.get_child(i).visible = false
		


func _on_SkillSButton_button_down():
	switch_panel_components(PanelComponent.Skills)


func _on_OptionsButton_button_down():
	switch_panel_components(PanelComponent.Options)


func _on_InventoryButton_button_down():
	switch_panel_components(PanelComponent.Inventory)


func _on_SaveButton_button_down():
	pass # Replace with function body.


func _on_Levels_level_changed():
	changePauseState()


func _on_Player_player_level_up(var player):
	$GameUI/XPIcon/Label.text = str(player.level)


func _on_Player_player_stats_changed(var player):
	$GameUI/HealthBar.max_value = player.health_max
	$GameUI/HealthBar.value = player.health
	$GameUI/XPBar.max_value = player.xp_next_level
	$GameUI/XPBar.value = player.xp
