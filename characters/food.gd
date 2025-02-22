extends Area2D

class_name Food

signal food_eaten

var initial_position: Vector2

func _ready():
	initial_position = position

func _on_body_entered(body):
	if body.is_in_group("player"):
		if visible:
			food_eaten.emit()
			visible = false

func reset_position():
	position = initial_position
	#visible = true
