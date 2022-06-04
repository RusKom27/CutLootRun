extends KinematicBody2D

var Stats = load("res://Scripts/ItemsData.gd").new().Stats

signal player_stats_changed
signal player_level_up
signal item_collide
signal item_out_collide
signal item_taked

var self_attack_damage = 30
var self_speed = 75
var self_health_max = 100
var self_health_regeneration = 1
var self_gold = 0

var attack_cooldown_time = 1000
var next_attack_time = 0

var health = 100

export var health_max = 0
export var attack_damage = 0
export var health_regeneration = 0
export var speed = 0
export var gold = 0

export var xp = 0
export var xp_next_level = 2
export var level = 0
export var upgrades = 0


var last_direction = Vector2(0, 1)
var last_turn = "right"
var attack_playing = false
var near_item = null

var items = []


func _ready():
	update_stats()
	emit_signal("player_stats_changed", self)
	emit_signal("player_level_up", self)

func _physics_process(delta):
	var direction: Vector2
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()
	
	var movement = speed * direction * delta
	
	if attack_playing:
		movement = 0 * movement
	
	var collision = move_and_collide(movement)
	
	if not attack_playing:
		animates_player(direction)
		
	if direction != Vector2.ZERO:
		var ray_cast = $RayCast2D
		var target_arrow = $TargetArrowUi
		ray_cast.cast_to = direction.normalized() * 16
		if ray_cast.cast_to.x == 0:
			target_arrow.rotation = deg2rad(clamp(180 * direction.y, 0, 180))
			ray_cast.scale.x = 6
			ray_cast.scale.y = 1
		elif ray_cast.cast_to.y == 0:
			target_arrow.rotation = deg2rad(90 * direction.x)
			ray_cast.scale.y = 6
			ray_cast.scale.x = 1
		else:
			target_arrow.rotation = deg2rad(45 * sign(direction.x) + 
											clamp(90 * sign(direction.y), 0, 90) * 
											sign(direction.x))
			$RayCast2D.scale.x = 1

func _process(delta):
	var new_health = min(health + health_regeneration * delta, health_max)
	if new_health != health:
		health = new_health
		emit_signal("player_stats_changed", self)

func _input(event):
	if event.is_action_pressed("ui_take"):
		if near_item != null:
			items.append(near_item.take())
			update_stats()
			emit_signal("item_taked", self)
	if event.is_action_pressed("attack"):
		var now = OS.get_ticks_msec()
		if not attack_playing and now >= next_attack_time:
			var target = $RayCast2D.get_collider()
			if target != null:
				if target.name.find("Goblin") >= 0:
					target.hit(attack_damage)
				if target.is_in_group("NPCs"):
					target.talk()
					return

			attack_playing = true
			var animation = "attack1"
			$AnimatedSprite.play(animation)
			next_attack_time = now + attack_cooldown_time
		elif not attack_playing:
			var target = $RayCast2D.get_collider()
			if target != null:
				if target.name.find("Goblin") >= 0:
					target.hit(attack_damage)
			attack_playing = true
			var animation = "attack2"
			$AnimatedSprite.play(animation)

func update_stats(add_stat = -1,add_value = 0):
	if add_stat != -1:
		self["self_" + Stats.keys()[add_stat]] += add_value
		upgrades -= 1
	for stat in Stats.keys():
		var items_stats = 0
		for item in items:
			for item_stat in item.stats:
				if item_stat == Stats.get(stat):
					items_stats += item.stats.get(item_stat)
		self[stat] = self["self_"+stat] + items_stats
	emit_signal("player_stats_changed", self)
		
func hit(damage):
	health -= damage
	emit_signal("player_stats_changed", self)
	if health <= 0:
		set_process(false)
	else:
		$AnimationPlayer.play("Hit")

func add_xp(value):
	xp += value
	while xp >= xp_next_level:
		level += 1
		xp_next_level *= 2
		upgrades += 1
		emit_signal("player_level_up", self)
	emit_signal("player_stats_changed", self)

func get_animation_direction(direction: Vector2):
	var norm_direction = direction.normalized()
	if norm_direction.x <= -0.707:
		return "left"
	elif norm_direction.x >= 0.707:
		return "right"
	else:
		return last_turn

func animates_player(direction: Vector2):
	last_turn = get_animation_direction(last_direction)
	if last_turn == "left":
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false
	if direction != Vector2.ZERO:
		# gradually update last_direction to counteract the bounce of the analog stick
		last_direction = 0.5 * last_direction + 0.5 * direction
		
		# Choose walk animation based on movement direction
		var animation = "run"
		
		# Choose FPS based on movement speed and then play the walk animation
		$AnimatedSprite.frames.set_animation_speed(animation, 2 + 8 * direction.length())
		$AnimatedSprite.play(animation)
	else:
		# Choose idle animation based on last movement direction and play it
		var animation = "idle"
		$AnimatedSprite.play(animation)



func _on_AnimatedSprite_animation_finished():
	attack_playing = false


func _on_Area2D_area_entered(area):
	if area.name == "ItemArea":
		var item = area.get_parent()
		near_item = item
		emit_signal("item_collide", item)


func _on_Area2D_area_exited(area):
	if area.name == "ItemArea":
		near_item = null
		emit_signal("item_out_collide", area.get_parent())
		

func _on_Skills_update_upgrades():
	update_stats()
