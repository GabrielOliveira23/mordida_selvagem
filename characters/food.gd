extends Area2D

class_name Food

signal food_eaten()

func _on_body_entered(body):
	if body.is_in_group("player"):
		food_eaten.emit()
		queue_free()
