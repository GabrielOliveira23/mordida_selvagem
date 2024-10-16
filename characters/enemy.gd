extends CharacterBody2D

@export var speed = 120
@export var player = Node2D
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

var player_chase = false
var direction = Vector2.RIGHT
var patrol_vertical = false

func _physics_process(_delta: float):
	if player_chase:
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = dir * speed
	else:
		if patrol_vertical:
			velocity.y = direction.y * speed
			velocity.x = 0
		else:
			velocity.x = direction.x * speed
			velocity.y = 0
	
	move_and_slide()

	if is_on_wall():
		if patrol_vertical:
			direction.y *= -1
		else:
			direction.x *= -1

func makepath() -> void:
	if player_chase:
		nav_agent.target_position = player.global_position

func _on_timer_timeout():
	makepath()

func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		player = body
		player_chase = true

func _on_detection_area_body_exited(body):
	if body == player:
		player = null
		player_chase = false

		if abs(velocity.y) > abs(velocity.x):
			patrol_vertical = true
			direction = Vector2.UP if velocity.y < 0 else Vector2.DOWN
		else:
			patrol_vertical = false
			direction = Vector2.LEFT if velocity.x < 0 else Vector2.RIGHT
