extends Area2D

func body_entered(body):
	if body.has_method("take_damage"):
		body.health -= body.health
		print(body.health)
