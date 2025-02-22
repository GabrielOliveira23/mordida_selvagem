extends CharacterBody2D

@export var speed = 0
@export var player = Node2D
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@onready var enemy = $Sprite2D
@onready var sprite = $Sprite2D

var player_chase = false
var direction = Vector2.RIGHT
var patrol_vertical = false
var initial_position: Vector2

var current_sprite = 2

func _ready():
	initial_position = global_position
	enemy.texture = load(Global.sprite_path_list[current_sprite])

func _physics_process(delta: float):
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
	
	var collision = move_and_collide(velocity * delta)
	if collision and collision.get_collider().is_in_group("player"):
		eat_player(collision.get_collider())

	if is_on_wall():
		if patrol_vertical:
			direction.y *= -1
		else:
			direction.x *= -1

func eat_player(player_node):
	player_node.take_damage(1)
	reset_position()

func reset_position():
	global_position = initial_position
	player_chase = false
	velocity = Vector2.ZERO

func makepath() -> void:
	if player_chase:
		nav_agent.target_position = player.global_position

func change_sprite():
	current_sprite += 1
	sprite.texture = load(Global.sprite_path_list[current_sprite])

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
