extends CharacterBody2D

@export var health = 500.0
@export var gravity = 6000.0
@export var friction = 1500.0

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
	move_and_slide()

func take_damage(damage: float, knockback: Vector2):
	health -= damage
	print(health)
	if health < 1:
		queue_free()
	else:
		velocity += knockback * 100
