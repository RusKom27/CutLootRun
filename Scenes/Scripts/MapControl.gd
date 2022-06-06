extends Node2D

onready var EnemyType = {
	0: "Goblin"
}

onready var items_data = load("res://Scripts/ItemsData.gd").new().items_data
onready var canvas = get_parent().get_node("CanvasLayer")

var current_level = 3


func _on_Levels_level_changed(var lvl):
	current_level = lvl
	change_lvl(current_level)
	
	
func change_lvl(lvl = "Home", load_data = {}, new_game = false):
	if "level" in load_data:
		current_level = load_data.level
		load_lvl(current_level)
		var player = $YSort/Player
		for stat in load_data.Player:
			if stat == "position":
				player[stat] = Vector2(load_data.Player[stat][0],load_data.Player[stat][1])
			if stat != "items":
				player[stat] = load_data.Player[stat]
		player.items.clear()
		for item_id in load_data.Player.items:
			player.items.append(items_data[int(item_id)])
		player.emit_signal("player_stats_changed", player)
		player.emit_signal("player_level_up", player)
		player.emit_signal("item_taked", player)
		for enemy in load_data.Enemies:
			if enemy.health != 0:
				var enemy_resource = load("res://Entities/Enemies/" + EnemyType[int(enemy.type)] + "/" + str(EnemyType[int(enemy.type)]) + ".tscn")
				var enemy_entity = enemy_resource.instance()
				enemy_entity.health = enemy.health
				enemy_entity.position = Vector2(enemy.position[0], enemy.position[1])
				$YSort.add_child(enemy_entity)
	else:
		current_level = lvl
		var level = load_lvl(current_level)
		var player = $YSort/Player
		if new_game:
			current_level = "Home"
			level = load_lvl(current_level)
			var default_player_stats = get_default_player_stats()
			for stat in default_player_stats:
				if stat != "items":
					player[stat] = default_player_stats[stat]
			player.items.clear()
			for item_id in default_player_stats.items:
				player.items.append(items_data[int(item_id)])
		player.transform = level.player_spawn.transform
		player.emit_signal("player_stats_changed", player)
		player.emit_signal("player_level_up", player)
		player.emit_signal("item_taked", player)
		
		for enemy_spawn in level.enemy_spawn.get_children():
			var enemy = load("res://Entities/Enemies/Goblin/Goblin.tscn")
			var enemy_entity = enemy.instance()
			enemy_entity.transform = enemy_spawn.transform
			$YSort.add_child(enemy_entity)
		
func load_lvl(var lvl):
	var level_resource
	match typeof(lvl):
		TYPE_STRING:
			level_resource = load("res://Scenes/Levels/" + lvl + ".tscn");
		TYPE_INT:
			level_resource = load("res://Scenes/Levels/Level" + str(lvl) + ".tscn");
		TYPE_REAL:
			level_resource = load("res://Scenes/Levels/Level" + str(lvl) + ".tscn");
	var level = level_resource.instance();
	remove_child($Level);
	for entity in $YSort.get_children():
		if entity != $YSort/Player:
			$YSort.remove_child(entity)
	add_child(level);
	$YSort.add_child(level.get_node("Decorations"))
	canvas.show_event_text("Level: " + str(current_level))
	canvas.change_level_name("Level: " + str(current_level))
	canvas.get_node("GameUI/LevelName").text = "Level: " + str(current_level)
	move_child(level, 0)
	return level

func get_default_player_stats():
	return {"position": Vector2(0,0),
			"last_turn": "left",
			"self_speed": 75,
			"health": 100,
			"self_health_regeneration": 1,
			"self_health_max": 100,
			"xp": 0,
			"xp_next_level": 30,
			"level": 0,
			"upgrades": 0,
			"self_attack_damage": 30,
			"self_gold": 0,
			"items": []}
