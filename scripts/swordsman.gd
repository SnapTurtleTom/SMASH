extends CharacterBody2D

var projectile = preload("res://scenes/grappling_hook.tscn")
@export var gravity = 6000.0
@export var speed = 500.0
@export var acceleration = 2000.0
@export var jump_force = -2500.0
@export var health = 100.0
var facing_direction := Vector2.RIGHT
var projectile_on = false
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
	$bigsword_bar.max_value = 1
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
		$swordsman_hitbox/swordsman_idle.flip_h = true
	elif facing_direction.x == 1:
		$swordsman_hitbox/swordsman_idle.flip_h = false
	
	
	if Input.is_action_just_pressed(speciala) and $swordsman_attackset.sword_on == false and attack_cooldown_on == false:
		$swordsman_attackset.sword_attack()
		attack_cooldown_on = true
		await get_tree().create_timer(1).timeout
		attack_cooldown_on = false
		
	
	$bigsword_bar.value = held_time
	if held_time != 0:
		$bigsword_bar.visible = true
	
	if Input.is_action_pressed(specialb):
		held_time += delta
	elif Input.is_action_just_released(specialb):
		if held_time > 1 and $swordsman_attackset.sword_on == false:
			held_time = 0
			$bigsword_bar.visible = false
			$swordsman_attackset.big_sword_attack()
			attack_cooldown_on = true
			await get_tree().create_timer(2).timeout
			attack_cooldown_on = false
		held_time = 0
		$bigsword_bar.visible = false
	
	if Input.is_action_just_pressed(specialc) and projectile_on == false:
		var p = projectile.instantiate()
		p.global_position = global_position
		p.direction = facing_direction
		p.owner_node = self
		get_tree().current_scene.add_child(p)
		projectile_on = true
		await get_tree().create_timer(3).timeout
		projectile_on = false
	
	if Input.is_action_just_pressed(speciald) and $swordsman_attackset.sword_on == false and attack_cooldown_on == false:
		$swordsman_attackset.spin_sword_attack()
		attack_cooldown_on = true
		await get_tree().create_timer(2).timeout
		attack_cooldown_on = false
	
	move_and_slide()

func take_damage(damage: float, knockback: Vector2):
	health -= damage
	print(health)
	if health < 1:
		queue_free()
	else:
		velocity += knockback * 100
