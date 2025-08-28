extends Area2D

var player = preload("res://scenes/base.tscn")
@export var speed = 800.0
@export var projectile_damage = 5
var direction := Vector2.RIGHT
var owner_node : Node2D
var player_type : String

func _ready():
	connect("body_entered", Callable(self, "body_entered"))
	if owner_node.player_type == 1:
		player_type = "player1"
	elif owner_node.player_type == 2:
		player_type = "player2"
	death_timer()

func _physics_process(delta):
	position.x += direction.x * speed * delta

func death_timer():
	await get_tree().create_timer(3).timeout
	queue_free()

func body_entered(body):
	print("dgd")
	if body != owner_node and body.has_method("take_damage"):
		body.take_damage(projectile_damage, direction * -15)
		queue_free()
