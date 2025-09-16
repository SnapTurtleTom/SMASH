extends CharacterBody2D

var bullet = preload("res://gunner_bullet.tscn")
var shotgun_bullet = preload("res://gunner_shotgun.tscn")
@export var gravity = 6000.0
@export var speed = 600.0
@export var acceleration = 2500.0
@export var jump_force = -2500.0
@export var health = 100.0
@export var sniper_bullet_speed = 2500.0
@export var sniper_bullet_damage = 10.0
@export var revolver_bullet_speed = 2000.0
@export var revolver_bullet_damage = 5.0
@export var revolver_bullets = 6
var revolver_reloading := false
var facing_direction := Vector2.RIGHT
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
	$revolver_bullet_amount.max_value = revolver_bullets
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
	$revolver_bullet_amount.value = revolver_bullets
	
	if revolver_reloading or revolver_bullets < 6:
		$revolver_bullet_amount.visible = true
	else:
		$revolver_bullet_amount.visible = false
	
	if facing_direction.x == -1:
		$gunner_hitbox/gunner_sprite.flip_h = true
	elif facing_direction.x == 1:
		$gunner_hitbox/gunner_sprite.flip_h = false
	
	if Input.is_action_just_pressed(speciala) and attack_cooldown_on == false:
		var p = bullet.instantiate()
		p.speed = sniper_bullet_speed
		p.projectile_damage = sniper_bullet_damage
		p.global_position = global_position
		p.direction = facing_direction
		p.owner_node = self
		p.knockback = 20
		get_tree().current_scene.add_child(p)
		attack_cooldown_on = true
		await get_tree().create_timer(2).timeout
		attack_cooldown_on = false
	
	if Input.is_action_just_pressed(specialb) and revolver_bullets > 0 and attack_cooldown_on == false and !revolver_reloading:
		var random_spawn = randi_range(-75, 25)
		var p = bullet.instantiate()
		p.speed = revolver_bullet_speed
		p.projectile_damage = revolver_bullet_damage
		p.global_position = global_position
		p.position.y += random_spawn
		p.direction = facing_direction
		p.owner_node = self
		p.knockback = 10
		get_tree().current_scene.add_child(p)
		revolver_bullets -= 1
		attack_cooldown_on = true
		await get_tree().create_timer(0.1).timeout
		attack_cooldown_on = false
	elif revolver_bullets == 0 and !revolver_reloading:
		revolver_reloading = true
		for i in 6:
			await get_tree().create_timer(1).timeout
			revolver_bullets += 1
			print(revolver_bullets)
		revolver_reloading = false
	
	if Input.is_action_just_pressed(specialc) and attack_cooldown_on == false:
		var a = shotgun_bullet.instantiate()
		var b = shotgun_bullet.instantiate()
		var c = shotgun_bullet.instantiate()
		a.global_position = global_position
		a.global_position.y -= 75
		a.direction = Vector2(0, -1)
		a.owner_node = self
		get_tree().current_scene.add_child(a)
		b.global_position = global_position
		b.global_position.y -= 75
		b.direction = Vector2(0.5, -1)
		b.owner_node = self
		get_tree().current_scene.add_child(b)
		c.global_position = global_position
		c.global_position.y -= 75
		c.direction = Vector2(-0.5, -1)
		c.owner_node = self
		get_tree().current_scene.add_child(c)
		attack_cooldown_on = true
		await get_tree().create_timer(1).timeout
		attack_cooldown_on = false
	
	if Input.is_action_just_pressed(speciald) and attack_cooldown_on == false:
		var a = shotgun_bullet.instantiate()
		var b = shotgun_bullet.instantiate()
		var c = shotgun_bullet.instantiate()
		a.global_position = global_position
		a.global_position.y -= 75
		a.direction = Vector2(0, 1)
		a.owner_node = self
		get_tree().current_scene.add_child(a)
		b.global_position = global_position
		b.global_position.y -= 75
		b.direction = Vector2(0.5, 1)
		b.owner_node = self
		get_tree().current_scene.add_child(b)
		c.global_position = global_position
		c.global_position.y -= 75
		c.direction = Vector2(-0.5, 1)
		c.owner_node = self
		get_tree().current_scene.add_child(c)
		attack_cooldown_on = true
		await get_tree().create_timer(1).timeout
		attack_cooldown_on = false
	
	move_and_slide()

func take_damage(damage: float, knockback: Vector2):
	health -= damage
	if health < 1:
		queue_free()
	else:
		velocity += knockback * 100
