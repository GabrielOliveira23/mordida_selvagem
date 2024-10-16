extends CharacterBody2D

@export var max_speed = 200
var input = Vector2.ZERO
var sprite: Sprite2D
@onready var collisionShape = $CollisionShape2D

func _ready():
	sprite = $Sprite2D
	#collisionShape.shape = CapsuleShape2D.new() # to reshape collision

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
