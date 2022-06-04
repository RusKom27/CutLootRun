enum Stats {
	attack_damage,
	health_max,
	health_regeneration,
	speed,
	gold
}


class Item:
	var name : String = "item"
	var texture : Resource
	var stats : Dictionary = {}
	
	func _init(_name : String, _texture : String, _stats : Dictionary):
		name = _name
		texture = load("res://Entities/Items/Frames/" + _texture)
		stats = _stats
		

var items_data = {
	"0": Item.new(
		"Boots", 
		"boots.png", 
		{Stats.speed: 15}),
		
	"1": Item.new(
		"Health Potion", 
		"health_potion.png", 
		{ Stats.health_max: 20 }),
		
	"2": Item.new(
		"Stone of Regeneration", 
		"stone_of_regeneration.png", 
		{ Stats.health_regeneration: 0.5 }),
		
	"3": Item.new(
		"Knife", 
		"knife.png", 
		{ Stats.attack_damage: 20 }),
		
	"4": Item.new(
		"Gold", 
		"gold.png", 
		{ Stats.gold: 30 }),
}
