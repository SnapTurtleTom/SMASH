extends Area2D

var player = preload("res://scenes/gunner/gunner.tscn")
var speed := 2250.0
var projectile_damage := 5.0
var direction : Vector2
var owner_node : Node2D
var player_type : String
var knockback := 12.5

func _ready():
	connect("body_entered", Callable(self, "body_entered"))
	if owner_node.player_type == 1:
		player_type = "player1"
	elif owner_node.player_type == 2:
		player_type = "player2"
	death_timer()

func _physics_process(delta):
	position += direction * speed * delta

func death_timer():
	await get_tree().create_timer(2).timeout
	queue_free()

func body_entered(body):
	if body != owner_node and body.has_method("take_damage"):
		body.take_damage(projectile_damage, direction * knockback)
		queue_free()
