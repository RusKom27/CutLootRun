extends KinematicBody2D

signal player_stats_changed
signal player_level_up

export var speed = 75
var attack_cooldown_time = 1000
var next_attack_time = 0
var attack_damage = 30

var health = 100
var health_max = 100
var health_regeneration = 1
var mana = 100
var mana_max = 100
var mana_regeneration = 2
var xp = 0;
var xp_next_level = 100;
var level = 1;

var last_direction = Vector2(0, 1)
var last_turn = "right"
var attack_playing = false

func _ready():
	emit_signal("player_stats_changed", self)

func _physics_process(delta):
	# Get player input
	var direction: Vector2
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	# If input is digital, normalize it for diagonal movement
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()
	
	# Calculate movement
	var movement = speed * direction * delta
	
	if attack_playing:
		movement = 0 * movement
	
	# Execute movement
	var _moving = move_and_collide(movement)
	
	# Animate player based on direction
	if not attack_playing:
		animates_player(direction)
		
	if direction != Vector2.ZERO:
		$RayCast2D.cast_to = direction.normalized() * 16

func _process(delta):
	var new_health = min(health + health_regeneration * delta, health_max)
	if new_health != health:
		health = new_health
		emit_signal("player_stats_changed", self)

func _input(event):
	if event.is_action_pressed("attack"):
		# Check if player can attack
		var now = OS.get_ticks_msec()
		if not attack_playing and now >= next_attack_time:
			# What's the target?
			var target = $RayCast2D.get_collider()
			if target != null:
				if target.name.find("Goblin") >= 0:
					# Skeleton hit!
					target.hit(attack_damage)
				if target.is_in_group("NPCs"):
					# Talk to NPC
					target.talk()
					return
			# Play attack animation
			attack_playing = true
			var animation = "attack1"
			$AnimatedSprite.play(animation)
			# Add cooldown time to current time
			next_attack_time = now + attack_cooldown_time
		elif not attack_playing:
			var target = $RayCast2D.get_collider()
			if target != null:
				if target.name.find("Goblin") >= 0:
					# Skeleton hit!
					target.hit(attack_damage)
			attack_playing = true
			var animation = "attack2"
			$AnimatedSprite.play(animation)

func _on_AnimatedSprite_animation_finished():
	attack_playing = false
#	if $Sprite.animation.ends_with("_fireball"):
		# Instantiate Fireball
#		var fireball = fireball_scene.instance()
#		fireball.attack_damage = fireball_damage
#		fireball.direction = last_direction.normalized()
#		fireball.position = position + last_direction.normalized() * 4
#		print(last_direction)
#		fireball.rotation_degrees = 90 * last_direction[1] 
#		get_tree().root.get_node("Root").add_child(fireball)

func hit(damage):
	health -= damage
	emit_signal("player_stats_changed", self)
#	if health <= 0:
#		set_process(false)
#	else:
#		$AnimationPlayer.play("Hit")

func add_xp(value):
	xp += value
	if xp >= xp_next_level:
		level += 1
		xp_next_level *= 2
		emit_signal("player_level_up")
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

