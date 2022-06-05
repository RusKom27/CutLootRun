extends Node

var Stats = {
	"attack_damage":"attack_damage",
	"health_max":"health_max",
	"health_regeneration":"health_regeneration",
	"speed":"speed",
	"gold":"gold",
}

class Item:
	var id : int = 0
	var name : String = "item"
	var texture : Resource
	var stats : Dictionary = {}
	
	func _init(_id: int, _name : String, _texture : String, _stats : Dictionary):
		id = _id
		name = _name
		texture = load("res://Entities/Items/Frames/" + _texture)
		stats = _stats
		
		

var items_data = {
	0: Item.new(
		0,
		"Boots", 
		"boots.png", 
		{Stats.speed: 15}),
		
	1: Item.new(
		1,
		"Health Potion", 
		"health_potion.png", 
		{ Stats.health_max: 20 }),
		
	2: Item.new(
		2,
		"Stone of Regeneration", 
		"stone_of_regeneration.png", 
		{ Stats.health_regeneration: 0.5 }),
		
	3: Item.new(
		3,
		"Knife", 
		"knife.png", 
		{ Stats.attack_damage: 20 }),
		
	4: Item.new(
		4,
		"Gold", 
		"gold.png", 
		{ Stats.gold: 30 }),
}
