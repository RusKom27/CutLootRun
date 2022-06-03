extends Node2D


func _ready():
	change_lvl("Home")


func _on_Levels_level_changed(var lvl):
	change_lvl(lvl)
	
	
func change_lvl(var lvl):
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
	move_child(level, 0)
	$YSort/Player.transform = level.player_spawn.transform
	for enemy in level.enemy_spawn.get_children():
		var goblin_enemy = load("res://Entities/Enemies/Goblin/Goblin.tscn")
		var enemy_entity = goblin_enemy.instance()
		enemy_entity.transform = enemy.transform
		$YSort.add_child(enemy_entity)
