extends Node2D
var base = preload("res://scenes/base.tscn")
var gunner = preload("res://scenes/gunner.tscn")
var key_pressed : String
var starting_player_type = 0

func _ready():
	spawn()

func _input(event):
	if event is InputEventKey:
		key_pressed = event.as_text_key_label()

func spawn():
	for i in range(2):
		while !Input.is_action_just_pressed("Spawn"):
			await get_tree().process_frame
		if key_pressed == "1":
			starting_player_type += 1
			var new = base.instantiate()
			new.position = Vector2(-1000, -500)
			if starting_player_type == 1:
				new.player_type = 1
				print(new.player_type)
			elif starting_player_type == 2:
				new.player_type = 2
				print(new.player_type)
			add_child(new)
			Global.player1 = get_node("/root/Node2D/Player")
		
		elif key_pressed == "2":
			var new = gunner.instantiate()
			new.position = Vector2(-1000, -500)
			add_child(new)
			Global.player2 = get_node("/root/Node2D/Gunner")
		
		while Input.is_action_just_pressed("Spawn"):
			await get_tree().process_frame
