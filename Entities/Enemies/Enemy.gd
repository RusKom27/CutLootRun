extends KinematicBody2D

signal death

var player : KinematicBody2D

var rng = RandomNumberGenerator.new()
var item_drop_resource = load("res://Entities/Items/Item.tscn")
var StatChangeText_resource = load("res://UI/Templates/StatChangeText.tscn")

onready var RayCast2D = $RayCast2D
onready var AnimatedSprite = $AnimatedSprite
onready var Timer = $Timer
onready var AnimationPlayer = $AnimationPlayer
onready var HealthBar = $HealthPanel/HealthBar
onready var HealthPanelLabel = $HealthPanel/Label
onready var Label = $Label

export(int) var type = 0
export var enemy_name = "Enemy"
export(int) var health = 100
export(int) var health_max = 100
export var health_regeneration = 1
export(int) var attack_damage = 10
export var speed = 35

var attack_cooldown_time = 1500
var next_attack_time = 0
var direction : Vector2
var last_direction = Vector2(0, 1)
var last_turn = "right"
var bounce_countdown = 0

var animation_name = {
	"idle": "idle",
	"run": "run",
	"attack": "attack",
	"get_hit": "get_hit",
	"birth": "birth",
	"death": "death",
}

var other_animation_playing = false
var is_attacking = false;


func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	Label.text = enemy_name
	HealthBar.max_value = self.health_max
	HealthBar.value = self.health
	HealthPanelLabel.text = str(int(clamp(health, 0, health_max))) + "/" + str(health_max)
	rng.randomize()
	arise()

	
func _process(delta):
	health = min(health + health_regeneration * delta, health_max)
	HealthBar.value = self.health
	HealthPanelLabel.text = str(int(clamp(health, 0, health_max))) + "/" + str(health_max)
	var now = OS.get_ticks_msec()
	if now >= next_attack_time:
		var target = RayCast2D.get_collider()
		if target != null and target.name == player.name and player.health > 0:
			other_animation_playing = true
			var animation = animation_name.attack
			is_attacking = true
			AnimatedSprite.play(animation)
			next_attack_time = now + attack_cooldown_time

func _physics_process(delta):
	var movement = direction * speed * delta
	if is_attacking:
		movement = direction * 0 * delta
	var collision = move_and_collide(movement)
	if collision != null and collision.collider.name != player.name:
		direction = direction.rotated(rng.randf_range(PI/4, PI/2))
		bounce_countdown = rng.randi_range(2, 5)
	if not other_animation_playing:
		animation(direction)
	if direction != Vector2.ZERO:
		RayCast2D.cast_to = direction.normalized() * 16

func animation(direction: Vector2):
	last_turn = get_animation_direction(last_direction)
	if last_turn == "left":
		AnimatedSprite.flip_h = true
	else:
		AnimatedSprite.flip_h = false
	if direction != Vector2.ZERO:
		last_direction = direction
		var animation = animation_name.run
		AnimatedSprite.play(animation)
	else:
		var animation = animation_name.idle
		AnimatedSprite.play(animation)

func get_animation_direction(direction: Vector2):
	var norm_direction = direction.normalized()
	if sign(norm_direction.x) <= -1:
		return "left"
	elif sign(norm_direction.x) >= 1:
		return "right"
	else:
		return last_turn

func arise():
	add_to_group("Enemy")
	other_animation_playing = true
	AnimatedSprite.play(animation_name.birth)

func hit(damage):
	health -= damage
	show_stat_change(-damage)
	if health <= 0:
		HealthBar.value = health
		HealthPanelLabel.text = str(int(clamp(health, 0, health_max))) + "/" + str(health_max)
		Timer.stop()
		direction = Vector2.ZERO
		set_process(false)
		other_animation_playing = true
		AnimatedSprite.play(animation_name.death)
		emit_signal("death")
		player.add_xp(25)
	else:
		AnimationPlayer.play(animation_name.get_hit)
		HealthBar.value = health
		HealthPanelLabel.text = str(int(clamp(health, 0, health_max))) + "/" + str(health_max)

func show_stat_change(stat):
	var StatChangeText = StatChangeText_resource.instance()
	StatChangeText.set_stat(stat)
	add_child(StatChangeText)

func _on_AnimatedSprite_animation_finished():
	if AnimatedSprite.animation == animation_name.birth:
		AnimatedSprite.animation = animation_name.idle
		Timer.start()
	elif AnimatedSprite.animation == animation_name.death:
		get_tree().queue_delete(self)
		var item_drop = item_drop_resource.instance()
		item_drop.set_item_data(rng.randi())
		item_drop.position = position
		item_drop.add_to_group("Item")
		get_parent().add_child(item_drop)
	other_animation_playing = false


func _on_Timer_timeout():
	if player != null:
		var player_relative_position = player.position - position
		if player_relative_position.length() <= 16:
			direction = Vector2.ZERO
			last_direction = player_relative_position.normalized()
		elif player_relative_position.length() <= 80 and bounce_countdown == 0:
			direction = player_relative_position.normalized()
			RayCast2D.cast_to = player_relative_position.normalized()
		elif bounce_countdown == 0:
			var random_number = rng.randf()
			if random_number < 0.05:
				direction = Vector2.ZERO
			elif random_number < 0.1:
				direction = Vector2.DOWN.rotated(rng.randf() * 2 * PI)
		if bounce_countdown > 0:
			bounce_countdown = bounce_countdown - 1


func _on_AnimatedSprite_frame_changed():
	if AnimatedSprite.animation.ends_with(animation_name.attack) and AnimatedSprite.frame == 6:
		var target = RayCast2D.get_collider()
		if target != null and target.name == player.name and player.health > 0:
			player.hit(attack_damage)
		is_attacking = false

