extends CharacterBody2D

var rain = preload("res://scenes/wizard_rain.tscn")
@export var gravity = 6000.0
@export var speed = 450.0
@export var acceleration = 2000.0
@export var jump_force = -2250.0
@export var health = 100.0
var facing_direction := Vector2.RIGHT
var held_time : float
var attack_cooldown_on = false
var jump_amount = 1

var player_type : int
var jump : String
var left : String
var right : String
var speciala : String
var specialb : String
var specialc : String
var speciald : String

func _ready():
	$HealthBar.max_value = health
	if player_type == 1:
		jump = "jump1"
		left = "left1"
		right = "right1"
		speciala = "speciala1"
		specialb = "specialb1"
		specialc = "specialc1"
		speciald = "speciald1"
	elif player_type == 2:
		jump = "jump2"
		left = "left2"
		right = "right2"
		speciala = "speciala2"
		specialb = "specialb2"
		specialc = "specialc2"
		speciald = "speciald2"

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity * delta
	else:
		if jump_amount < 1:
			jump_amount = 1
	
	if jump_amount > 0 and Input.is_action_just_pressed(jump):
		if is_on_floor() == false:
			jump_amount -= 1
		velocity.y = jump_force
	
	var input_dir = Input.get_axis(left, right)
	if input_dir != 0:
		facing_direction = Vector2(sign(input_dir), 0)
	velocity.x = move_toward(velocity.x, input_dir * speed, acceleration * delta)
	
	if self.position.y > 3000:
		queue_free()
	$HealthBar.value = health
	
	if facing_direction.x == -1:
		$wizard_hitbox/wizard_sprite.flip_h = true
	elif facing_direction.x == 1:
		$wizard_hitbox/wizard_sprite.flip_h = false
	
	if Input.is_action_just_pressed(speciala) and attack_cooldown_on == false:
		var dir = 0
		if facing_direction.x > 0:
			dir = 1
		else:
			dir = -1
		attack_cooldown_on = true
		for i in 50:
			var random_spawn = randi_range(-250, 500)
			var a = rain.instantiate()
			a.global_position = global_position
			a.global_position.y -= 1200
			if dir == 1:
				a.global_position.x += 750
				a.global_position.x += random_spawn
			else:
				a.global_position.x += -750
				a.global_position.x += -random_spawn
			a.direction = Vector2(0, 1)
			a.owner_node = self
			get_tree().current_scene.add_child(a)
			await get_tree().create_timer(0.01).timeout
		await get_tree().create_timer(1.99).timeout
		attack_cooldown_on = false
	
	move_and_slide()

func take_damage(damage: float, knockback: Vector2):
	health -= damage
	if health < 1:
		queue_free()
	else:
		velocity += knockback * 100
