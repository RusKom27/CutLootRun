extends Node2D

onready var EnemyType = {
	0: "Goblin"
}

onready var items_data = load("res://Scripts/ItemsData.gd").new().items_data
onready var canvas = get_parent().get_node("CanvasLayer")

var current_level = 3


func _ready():
	change_lvl(current_level)


func _on_Levels_level_changed(var lvl):
	current_level = lvl
	change_lvl(current_level)
	
	
func change_lvl(lvl = "Home", load_data = {}):
	if len(load_data) < 1:
		var level = load_lvl(lvl)
		print(lvl)
		$YSort/Player.transform = level.player_spawn.transform
		for enemy_spawn in level.enemy_spawn.get_children():
			var enemy = load("res://Entities/Enemies/Goblin/Goblin.tscn")
			var enemy_entity = enemy.instance()
			enemy_entity.transform = enemy_spawn.transform
			$YSort.add_child(enemy_entity)
	else:
		var level = load_lvl(load_data.level)
		var player = $YSort/Player
		for stat in load_data.Player:
			if stat != "items":
				player[stat] = load_data.Player[stat]
			player.emit_signal("player_stats_changed", player)
			player.emit_signal("player_level_up")
		for item_id in load_data.Player.items:
			player.items.append(items_data[item_id])
		for enemy in load_data.Enemies:
			var enemy_resource = load("res://Entities/Enemies/" + EnemyType[enemy.type] + "/" + EnemyType[enemy.type] + ".tscn")
			var enemy_entity = enemy_resource.instance()
			enemy_entity.health = enemy.health
			enemy_entity.position = enemy.position
			$YSort.add_child(enemy_entity)
		
func load_lvl(var lvl):
	var level_resource
	match typeof(lvl):
		TYPE_STRING:
			level_resource = load("res://Scenes/Levels/" + lvl + ".tscn");
		TYPE_INT:
			level_resource = load("res://Scenes/Levels/Level" + str(lvl) + ".tscn");
	var level = level_resource.instance();
	remove_child($Level);
	for entity in $YSort.get_children():
		if entity != $YSort/Player:
			$YSort.remove_child(entity)
	add_child(level);
	canvas.show_event_text("Level: " + str(current_level))
	canvas.change_level_name("Level: " + str(current_level))
	canvas.get_node("GameUI/LevelName").text = "Level: " + str(current_level)
	move_child(level, 0)
	return level
