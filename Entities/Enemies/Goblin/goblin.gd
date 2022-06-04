extends KinematicBody2D

signal death

# Node references
var player

# Random number generator
var rng = RandomNumberGenerator.new()

var item_drop_resource = load("res://Entities/Items/Item.tscn")

# Skeleton stats
var health = 100
var health_max = 100
var health_regeneration = 1

# Attack variables
var attack_damage = 10
var attack_cooldown_time = 1500
var next_attack_time = 0

# Movement variables
export var speed = 35
var direction : Vector2
var last_direction = Vector2(0, 1)
var last_turn = "right"
var bounce_countdown = 0

# Animation variables
var other_animation_playing = false
var is_attacking = false;

func _ready():
	arise()
	player = get_tree().root.get_node("Root/Map/YSort/Player")
	$HealthBar.max_value = health_max
	$HealthBar.value = health	
	rng.randomize()


func _process(delta):
	# Regenerates health
	health = min(health + health_regeneration * delta, health_max)
	
	# Check if Skeleton can attack
	var now = OS.get_ticks_msec()
	if now >= next_attack_time:
		# What's the target?
		var target = $RayCast2D.get_collider()
		if target != null and target.name == "Player" and player.health > 0:
			# Play attack animation
			other_animation_playing = true
			var animation = "attack"
			is_attacking = true
			$AnimatedSprite.play(animation)
			# Add cooldown time to current time
			next_attack_time = now + attack_cooldown_time

func _physics_process(delta):
	var movement = direction * speed * delta
	if is_attacking:
		movement = direction * 0 * delta
	var collision = move_and_collide(movement)
	
	if collision != null and collision.collider.name != "Player":
		direction = direction.rotated(rng.randf_range(PI/4, PI/2))
		bounce_countdown = rng.randi_range(2, 5)
	
	# Animate skeleton based on direction
	if not other_animation_playing:
		animates_monster(direction)
	
	# Turn RayCast2D toward movement direction
	if direction != Vector2.ZERO:
		$RayCast2D.cast_to = direction.normalized() * 16

func animates_monster(direction: Vector2):
	last_turn = get_animation_direction(last_direction)
	if last_turn == "left":
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false
	if direction != Vector2.ZERO:
		last_direction = direction
		
		# Choose walk animation based on movement direction
		var animation = "run"
		
		# Play the walk animation
		$AnimatedSprite.play(animation)
	else:
		# Choose idle animation based on last movement direction and play it
		var animation = "idle"
		$AnimatedSprite.play(animation)

func get_animation_direction(direction: Vector2):
	var norm_direction = direction.normalized()
	if norm_direction.x <= -0.707:
		return "left"
	elif norm_direction.x >= 0.707:
		return "right"
	else:
		return last_turn

func arise():
	other_animation_playing = true
	$AnimatedSprite.play("birth")

func hit(damage):
	health -= damage
	if health > 0:
		$AnimationPlayer.play("get_hit")
		$HealthBar.value = health
	else:
		$HealthBar.value = health
		$Timer.stop()
		direction = Vector2.ZERO
		set_process(false)
		other_animation_playing = true
		$AnimatedSprite.play("death")
		emit_signal("death")
		player.add_xp(25)

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "birth":
		$AnimatedSprite.animation = "idle"
		$Timer.start()
	elif $AnimatedSprite.animation == "death":
		get_tree().queue_delete(self)
		var item_drop = item_drop_resource.instance()
		item_drop.position = position
		get_parent().add_child(item_drop)
	other_animation_playing = false


func _on_Timer_timeout():
	# Calculate the position of the player relative to the skeleton
	if player != null:
		var player_relative_position = player.position - position
		
		if player_relative_position.length() <= 16:
			# If player is near, don't move but turn toward it
			direction = Vector2.ZERO
			last_direction = player_relative_position.normalized()
		elif player_relative_position.length() <= 80 and bounce_countdown == 0:
			# If player is within range, move toward it
			direction = player_relative_position.normalized()
			$RayCast2D.cast_to = player_relative_position.normalized()
		elif bounce_countdown == 0:
			# If player is too far, randomly decide whether to stand still or where to move
			var random_number = rng.randf()
			if random_number < 0.05:
				direction = Vector2.ZERO
			elif random_number < 0.1:
				direction = Vector2.DOWN.rotated(rng.randf() * 2 * PI)
		
		# Update bounce countdown
		if bounce_countdown > 0:
			bounce_countdown = bounce_countdown - 1


func _on_AnimatedSprite_frame_changed():
	if $AnimatedSprite.animation.ends_with("attack") and $AnimatedSprite.frame == 3:
		var target = $RayCast2D.get_collider()
		if target != null and target.name == "Player" and player.health > 0:
			player.hit(attack_damage)
		is_attacking = false
			
