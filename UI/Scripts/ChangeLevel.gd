extends Control

func change_level(var lvl):
	var map = get_tree().root.get_node("Root/Map");
	var player = map.get_node("Level/YSort/Player");
	var level_resource
	match typeof(lvl):
		TYPE_STRING:
			level_resource = load("res://Scenes/Levels/" + lvl + ".tscn");
		TYPE_INT:
			level_resource = load("res://Scenes/Levels/Level" + str(lvl) + ".tscn");
	var level = level_resource.instance();
	map.remove_child(map.get_children()[0]);
	map.add_child(level);

func _on_Cell1_button_down():
	change_level(1);
	
func _on_Cell2_button_down():
	change_level(2)
	
func _on_Home_button_down():
	change_level("Home")
