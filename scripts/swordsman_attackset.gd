extends Area2D

@export var sword_damage = 10.0
@export var big_sword_damage = 30.0
@export var spin_sword_damage = 2.5
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
	current_knockback = 12.5
	owner_node.speed = 750.0
	dir = owner_node.facing_direction
	scale.x = owner_node.facing_direction.x
	$sword.visible = true
	$sword.disabled = false
	sword_on = true
	await get_tree().create_timer(0.5).timeout
	sword_on = false
	$sword.visible = false
	$sword.disabled = true
	owner_node.speed = 500.0

func big_sword_attack():
	current_damage = big_sword_damage
	current_knockback = 17.5
	dir = owner_node.facing_direction
	get_parent().get_node("swordsman_hitbox/swordsman_idle").visible = false
	get_parent().get_node("swordsman_hitbox/swordsman_rolling").visible = true
	$bigsword.visible = true
	$bigsword.disabled = false
	sword_on = true
	await get_tree().create_timer(0.5).timeout
	get_parent().get_node("swordsman_hitbox/swordsman_idle").visible = true
	get_parent().get_node("swordsman_hitbox/swordsman_rolling").visible = false
	sword_on = false
	$bigsword.visible = false
	$bigsword.disabled = true

func spin_sword_attack():
	current_damage = spin_sword_damage
	current_knockback = 20
	dir = Vector2(scale.x / 2, -1)
	owner_node.speed = 1500.0
	owner_node.acceleration = 1000.0
	owner_node.gravity = 3000
	get_parent().get_node("swordsman_hitbox/swordsman_idle").visible = false
	get_parent().get_node("swordsman_hitbox/swordsman_spinning").visible = true
	sword_on = true
	$spinsword.visible = true
	$spinsword.disabled = false
	for i in 10:
		await get_tree().create_timer(0.05).timeout
		scale.x = 1
		dir = Vector2(scale.x / 3, -1)
		await get_tree().create_timer(0.05).timeout
		scale.x = -1
		dir = Vector2(scale.x / 3, -1)
	owner_node.speed = 500.0
	owner_node.acceleration = 2000.0
	owner_node.gravity = 6000.0
	get_parent().get_node("swordsman_hitbox/swordsman_idle").visible = true
	get_parent().get_node("swordsman_hitbox/swordsman_spinning").visible = false
	sword_on = false
	$spinsword.visible = false
	$spinsword.disabled = true
	

func body_entered(body):
	if body != owner_node and body.has_method("take_damage"):
		body.take_damage(current_damage, dir * current_knockback)
