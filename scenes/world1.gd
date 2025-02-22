extends Node2D

@onready var menu = preload("res://ui/start_menu.tscn").instantiate()
@onready var player = $Player
@onready var enemies = $Enemies.get_children()
@onready var foods_node = $Foods
@onready var foods = $Foods.get_children() as Array[Food]

var game_started = false

func _ready():
	Global.food_eaten = 0
	Global.current_phase = 1
	add_child(menu)
	if menu:
		menu.start_game.connect(_on_start_game)
		menu.return_to_main_menu.connect(_on_return_to_main_menu)
	
	if player:
		player.player_take_damage.connect(_on_player_take_damage)
		player.player_died.connect(_on_player_died)
	
	if foods_node:
		foods_node.change_sprites.connect(_on_change_sprites)
		foods_node.reset_positions.connect(_on_foods_reset_positions)
	
	show_menu()

func show_menu():
	if menu:
		menu.visible = true
	game_started = false
	pause_game(true)

func hide_menu():
	if menu:
		menu.visible = false
	game_started = true
	pause_game(false)

func pause_game(paused: bool):
	get_tree().paused = paused

func reset_world(reset_foods=false):
	if player:
		player.reset_position()
	for enemy in enemies:
		if enemy:
			enemy.reset_position()
	if reset_foods:
		for food in foods:
			if food and not food.visible:
				food.reset_position()
				food.visible = true

func _on_start_game():
	hide_menu()
	reset_world()

func _on_return_to_main_menu():
	pause_game(false)
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")

func _on_player_take_damage():
	show_menu()

func _on_player_died():
	_on_return_to_main_menu()

func _on_foods_reset_positions():
	reset_world(true)

func _on_change_sprites():
	player.change_sprite()
	for enemy in enemies:
		enemy.change_sprite()
