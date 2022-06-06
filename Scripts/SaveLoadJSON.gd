extends Node

signal saved
signal loaded


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
		var enemy_data = {}
		for stat in get_data_template().Enemies[0]:
			if typeof(enemy[stat]) == TYPE_VECTOR2:
				enemy_data[stat] = var2str(enemy[stat])
			else:
				enemy_data[stat] = enemy[stat]
		if enemy_data.health != 0:
			data.Enemies.append(enemy_data)
	data.level = map.current_level
	file.store_line(to_json(data))
	emit_signal("saved")
	var ContinueButton = get_parent().get_node("StartMenu/MenuCanvas/Buttons/ContinueButton")
	file.close()
	ContinueButton.disabled = false
	ContinueButton.modulate = Color.white
	data = {}


func load_game():
	var map = get_node(map_node)
	var file = File.new()
	file.open(SAVE_DIR+SAVE_FILE, File.READ)
	var data = parse_json(file.get_line())
	for item in data.Player:
		var value = data.Player[item]
		if typeof(value) == TYPE_STRING:
			data.Player[item] = str2var(value)
	for item in range(len(data.Enemies)):
		for stat in data.Enemies[item]:
			if typeof(data.Enemies[item][stat]) == TYPE_STRING:
				data.Enemies[item][stat] = str2var(data.Enemies[item][stat])
	map.change_lvl("",data)
	emit_signal("loaded")
	file.close()

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
