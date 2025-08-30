extends Area2D

@export var sword_damage = 10.0
@export var big_sword_damage = 30.0
@export var spin_sword_damage = 10.0
var owner_node : Node2D
var dir : Vector2 = Vector2.ZERO
var sword_on = false
var current_damage : float
var current_knockback : float

func _ready():
	owner_node = get_parent()
	dir = owner_node.facing_direction
	$sword.visible = false
	$sword.disabled = true
	$bigsword.visible = false
	$bigsword.disabled = true
	$spinsword.visible = false
	$spinsword.disabled = true
	connect("body_entered", Callable(self, "body_entered"))

func sword_attack():
	current_damage = sword_damage
	current_knockback = sword_damage
	dir = owner_node.facing_direction
	scale.x = owner_node.facing_direction.x
	$sword.visible = true
	$sword.disabled = false
	sword_on = true
	await get_tree().create_timer(0.5).timeout
	sword_on = false
	$sword.visible = false
	$sword.disabled = true

func big_sword_attack():
	current_damage = big_sword_damage
	current_knockback = 15
	dir = owner_node.facing_direction
	$bigsword.visible = true
	$bigsword.disabled = false
	sword_on = true
	await get_tree().create_timer(0.5).timeout
	sword_on = false
	$bigsword.visible = false
	$bigsword.disabled = true

func spin_sword_attack():
	current_damage = spin_sword_damage
	current_knockback = 15
	$spinsword.visible = true
	$spinsword.disabled = false
	sword_on = true
	for i in 5:
		await get_tree().create_timer(0.05).timeout
		scale.x = 1
		dir = Vector2(scale.x, -1)
		await get_tree().create_timer(0.05).timeout
		scale.x = -1
		dir = Vector2(scale.x, -1)
	sword_on = false
	$spinsword.visible = false
	$spinsword.disabled = true
	

func body_entered(body):
	if body != owner_node and body.has_method("take_damage"):
		print("dgd")
		body.take_damage(current_damage, dir * current_knockback)
