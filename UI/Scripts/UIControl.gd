extends CanvasLayer

signal paused

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
onready var EventText_resource = load("res://UI/Templates/EventText.tscn")

var level_name = ""

	

func changePauseState():
	tree.paused = !tree.paused
	$Menu.visible = tree.paused
	$GameUI.visible = !tree.paused
	switch_panel_components(PanelComponent.Levels)
	emit_signal("paused", tree.paused)


func show_event_text(text):
	var EventText = EventText_resource.instance()
	EventText.set_event_text(text)
	add_child(EventText)


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		changePauseState()

func _on_PauseButton_button_down():
	changePauseState()


func _on_ContinueButton_button_down():
	changePauseState()


func _on_ExitButton_button_down():
	get_parent().exit_game()


func switch_panel_components(needed_component: int):
	$AnimationPlayer.play("Switch_out")
	$Menu/Panel.visible = true
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
	get_parent().get_node("SaveLoadNode").save_game()


func _on_Levels_level_changed(var _lvl):
	changePauseState()


func _on_Player_player_level_up(var player):
	$GameUI/XPIcon/levels.text = str(player.level)
	if player.upgrades > 0:
		$GameUI/XPIcon/upgrades.text = "+" + str(player.upgrades)
	else:
		$GameUI/XPIcon/upgrades.text = ""


func _on_Player_player_stats_changed(var player):
	$GameUI/HealthBar.max_value = player.health_max
	$GameUI/HealthBar.value = player.health
	$GameUI/HealthIcon/Label.text = str(int(player.health)) + "/" + str(player.health_max)
	$GameUI/XPBar.max_value = player.xp_next_level
	$GameUI/XPBar.value = player.xp
	$GameUI/Gold.text = str(player.gold)


func _on_Skills_update_upgrades(var player):
	if player.upgrades > 0:
		$GameUI/XPIcon/upgrades.text = "+" + str(player.upgrades)
	else:
		$GameUI/XPIcon/upgrades.text = ""

func change_level_name(var _level_name):
	level_name = _level_name
	$GameUI/LevelName/AnimationPlayer.play("hide")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "hide":
		$GameUI/LevelName.text = level_name
		$GameUI/LevelName/AnimationPlayer.play("show")


func _on_SaveLoadNode_loaded():
	show_event_text("Loaded!")


func _on_SaveLoadNode_saved():
	show_event_text("Saved!")
