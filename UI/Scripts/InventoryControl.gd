extends Control

var Stats = preload("res://Scripts/ItemsData.gd").new().Stats
var inventory_slot_resource = load("res://UI/Templates/InventorySlot.tscn")
var player = null


func _ready():
	for i in range(20):
		var inventory_slot = inventory_slot_resource.instance()
		$GridContainer.add_child(inventory_slot)


func update_items():
	for i in range(len(player.items)):
		var inventory_slot = $GridContainer.get_child(i).get_node("AnimationPlayer")
		var item = player.items[i]
		inventory_slot.get_parent().get_node("ItemIcon").texture = item.texture
		inventory_slot.get_node("Name").text = item.name
		inventory_slot.get_node("Stats").text = ""
		for stat in item.stats:
			inventory_slot.get_node("Stats").text += "\n" + Stats[stat] + ": " + str(item.stats.get(stat))


func _on_Player_item_taked(var _player):
	var canvas = get_parent().get_parent().get_parent()
	canvas.show_event_text("Taken " + _player.near_item.item_data.name)
	player = _player


func _on_Player_player_stats_changed(var _player):
	player = _player


func _on_Inventory_draw():
	update_items()
