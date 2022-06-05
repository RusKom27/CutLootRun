extends Node


export(NodePath) var map_node

const SAVE_DIR = "user://"
const SAVE_FILE = "save.json"# get_date() + ".json"



func save_game():
	var data = get_data_template()
	var file = File.new()
	file.open(SAVE_DIR+SAVE_FILE, File.WRITE)
	var map = get_node(map_node)
	var player = get_tree().get_nodes_in_group("Player")[0]
	for stat in data.Player:
		if typeof(player[stat]) == TYPE_VECTOR2:
			data.Player[stat] = var2str(player[stat])
		elif typeof(player[stat]) == TYPE_ARRAY:
			for item in player[stat]:
				data.Player[stat].append(item.id)
		else:
			data.Player[stat] = player[stat]

	var enemies = get_tree().get_nodes_in_group("Enemy")
	for enemy in enemies:
		var enemy_data = data.Enemies[0]
		for stat in data.Enemies[0]:
			if typeof(enemy[stat]) == TYPE_VECTOR2:
				enemy_data[stat] = var2str(enemy[stat])
			else:
				enemy_data[stat] = enemy[stat]
		data.Enemies.append(enemy_data)
	data.level = map.current_level
	file.store_line(to_json(data))
	file.close()
	data = {}


func load_game():
	var map = get_node(map_node)
	
	var file = File.new()
	file.open(SAVE_DIR+SAVE_FILE, File.READ)
	var data = parse_json(file.get_line())
#
#	var player = get_node(player_node)
#	player.position = str2var(save_dict.player.position)
#	player.health = str2var(save_dict.player.health)
#
#	for enemy in get_tree().get_nodes_in_group("enemy"):
#		enemy.queue_free()
#
#	var game = get_node(game_node)
#
#	for enemy_config in save_dict.enemies:
#		var enemy = load("res://enemy.tscn").instance()
#		enemy.position = str2var(enemy_config.position)
#		game.add_child(enemy)
	print(data)
	#map.change_lvl("",data)

func get_date():
	var datetime = OS.get_datetime()
	var output_date = ""
	for item in ["day", "month", "year"]:
		var value = str(datetime[item])
		if len(value) < 2:
			value = "0" + value
		output_date += value + "-"
	output_date[-1] = "_"
	for item in ["hour", "minute", "second"]:
		var value = str(datetime[item])
		if len(value) < 2:
			value = "0" + value
		output_date += value + "."
	output_date[-1] = ""
	return output_date

func get_data_template():
	return {
		"Player": {
			"position": Vector2(0,0),
			"last_turn": "left",
			"self_speed": 0,
			"health": 0,
			"self_health_regeneration": 0,
			"self_health_max": 0,
			"xp": 0,
			"xp_next_level": 0,
			"level": 0,
			"upgrades": 0,
			"self_attack_damage": 0,
			"self_gold": 0,
			"items": []
		},
		"Enemies": [
			{
				"type": 0,
				"position": Vector2(0,0),
				"health": 0
			},
			{
				"type": 0,
				"position": Vector2(0,0),
				"health": 0
			}],
		"level": "Home"
	}
