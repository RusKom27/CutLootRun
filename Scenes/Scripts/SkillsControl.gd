extends Control

signal update_upgrades

onready var player = get_tree().root.get_node("Root/Map/YSort/Player")
onready var Stats = player.Stats

func _ready():
	update_stats_on_UI()
	

func update_stats_on_UI():
	$Info/Health.text = "Health: " + str(player.self_health_max) + " + " + str(player.health_max - player.self_health_max)
	$Info/Damage.text = "Damage: " + str(player.self_attack_damage) + " + " + str(player.attack_damage - player.self_attack_damage)
	$Info/Regeneration.text = "Regeneration: " + str(player.self_health_regeneration) + " + " + str(player.health_regeneration - player.self_health_regeneration)
	$Info/Movement.text = "Movement: " + str(player.self_speed) + " + " + str(player.speed - player.self_speed)
	$Info/Upgrades.text = "Upgrades: " + str(player.upgrades)
	if player.upgrades > 0:
		for button in $Buttons.get_children():
			button.disabled = false
			modulate.a = 1
	else:
		for button in $Buttons.get_children():
			button.disabled = true
			modulate.a = 0.3
	emit_signal("update_upgrades")


func _on_AddHPButton_button_down():
	player.update_stats(Stats.health_max, 10)
	update_stats_on_UI()


func _on_AddDMGButton_button_down():
	player.update_stats(Stats.attack_damage, 15)
	update_stats_on_UI()


func _on_AddREGButton_button_down():
	player.update_stats(Stats.health_regeneration, 0.5)
	update_stats_on_UI()


func _on_AddMOVButton_button_down():
	player.update_stats(Stats.speed, 20)
	update_stats_on_UI()


func _on_Player_player_level_up():
	update_stats_on_UI()


func _on_Skills_draw():
	update_stats_on_UI()
