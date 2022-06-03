extends Control

signal update_upgrades

onready var player = get_tree().root.get_node("Root/Map/YSort/Player")

func _ready():
	update_stats_on_UI()
	

func update_stats_on_UI():
	$Info/Health.text = "Health: " + str(player.health_max)
	$Info/Damage.text = "Damage: " + str(player.attack_damage)
	$Info/Regeneration.text = "Regeneration: " + str(player.health_regeneration)
	$Info/Movement.text = "Movement: " + str(player.speed)
	$Info/Upgrades.text = "Upgrades: " + str(player.upgrades)
	if player.upgrades > 0:
		for button in $Buttons.get_children():
			button.disabled = false
			modulate.a = 1
	else:
		for button in $Buttons.get_children():
			button.disabled = true
			modulate.a = 0.3
	emit_signal("update_upgrades", player)


func _on_AddHPButton_button_down():
	player.upgrades -= 1
	player.health_max += 10
	update_stats_on_UI()


func _on_AddDMGButton_button_down():
	player.upgrades -= 1
	player.attack_damage += 5
	update_stats_on_UI()


func _on_AddREGButton_button_down():
	player.upgrades -= 1
	player.health_regeneration += 0.1
	update_stats_on_UI()


func _on_AddMOVButton_button_down():
	player.upgrades -= 1
	player.speed += 3
	update_stats_on_UI()


func _on_Player_player_level_up():
	update_stats_on_UI()



func _on_Skills_draw():
	print("Draw")
	update_stats_on_UI()
