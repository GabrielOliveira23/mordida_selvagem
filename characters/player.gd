extends CharacterBody2D

@export var max_speed = 400
@export var max_health = 5
@onready var collisionShape = $CollisionShape2D

var health = max_health
var input = Vector2.ZERO
var sprite: Sprite2D
var initial_position: Vector2
var current_sprite = 1

signal player_take_damage
signal player_died

func _ready():
	sprite = $Sprite2D
	initial_position = position
	sprite.texture = load(Global.sprite_path_list[current_sprite])

func _physics_process(delta: float) -> void:
	player_movement()
	move_and_slide()

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
		sprite.scale.x = 1
	elif Input.is_action_pressed('ui_left'):
		velocity.x -= 1
		sprite.scale.x = -1
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1
	elif Input.is_action_pressed('ui_up'):
		velocity.y -= 1

	velocity = velocity.normalized() * max_speed

func player_movement():
	get_input()

func take_damage(amount: int):
	health -= amount
	print("Player health:", health)
	
	if health <= 0:
		print("player died!")
		player_died.emit()
		queue_free()
		return
	
	player_take_damage.emit()

func reset_position():
	position = initial_position

func change_sprite():
	current_sprite += 1
	sprite.texture = load(Global.sprite_path_list[current_sprite])
