extends CharacterBody2D

var projectile = preload("res://scenes/grappling_hook.tscn")
@export var gravity = 6000.0
@export var speed = 500.0
@export var acceleration = 2000.0
@export var jump_force = -2000.0
@export var health = 100.0
var facing_direction := Vector2.RIGHT
var projectile_on = false
var held_time : float

var player_type : int
var jump : String
var left : String
var right : String
var speciala : String
var specialb : String
var specialc : String

func _ready():
	$HealthBar.max_value = health
	if player_type == 1:
		jump = "jump1"
		left = "left1"
		right = "right1"
		speciala = "speciala1"
		specialb = "specialb1"
		specialc = "specialc1"
	elif player_type == 2:
		jump = "jump2"
		left = "left2"
		right = "right2"
		speciala = "speciala2"
		specialb = "specialb2"
		specialc = "specialc2"

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity * delta
	
	if is_on_floor() and Input.is_action_just_pressed(jump):
		velocity.y += jump_force
	
	var input_dir = Input.get_axis(left, right)
	if input_dir != 0:
		facing_direction = Vector2(sign(input_dir), 0)
	velocity.x = move_toward(velocity.x, input_dir * speed, acceleration * delta)
	
	$HealthBar.value = health
	
	if facing_direction.x == -1:
		$CollisionShape2D/AnimatedSprite2D.flip_h = true
	elif facing_direction.x == 1:
		$CollisionShape2D/AnimatedSprite2D.flip_h = false
	
	if velocity.y > 3000:
		queue_free()
	
	if Input.is_action_just_pressed(speciala) and $attackset1.sword_on == false:
		$attackset1.sword_attack()
	
	if Input.is_action_pressed(specialb):
		held_time += delta
	elif Input.is_action_just_released(specialb):
		if held_time > 1 and $attackset1.sword_on == false:
			$attackset1.big_sword_attack()
		held_time = 0
	
	if Input.is_action_just_pressed(specialc):
		if projectile_on == false:
			var p = projectile.instantiate()
			p.global_position = global_position
			p.direction = facing_direction
			p.owner_node = self
			get_tree().current_scene.add_child(p)
			projectile_on = true
			await get_tree().create_timer(3).timeout
			projectile_on = false
	
	move_and_slide()

func take_damage(damage: float, knockback: Vector2):
	health -= damage
	print(health)
	if health < 1:
		queue_free()
	else:
		velocity += knockback * 100
