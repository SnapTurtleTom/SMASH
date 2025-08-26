extends CharacterBody2D

var gravity = 6000.0
var speed = 500.0
var acceleration = 2000.0
var jump_force = -2000.0
var health = 100.0
var facing_direction := Vector2.RIGHT

var jump = "jump1"
var left = "left1"
var right = "right1"
var speciala = "speciala1"
var specialb = "specialb1"
var specialc = "specialc1"

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity * delta
	
	if is_on_floor() and Input.is_action_just_pressed(jump):
		velocity.y += jump_force
	
	var input_dir = Input.get_axis(left, right)
	if input_dir != 0:
		facing_direction = Vector2(sign(input_dir), 0)
	velocity.x = move_toward(velocity.x, input_dir * speed, acceleration * delta)
	
	move_and_slide()
