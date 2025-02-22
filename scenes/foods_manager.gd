extends Node

signal reset_positions
signal change_sprites

var total_food_count
var current_sprite = 0
var foods

func _ready():
	foods = self.get_children() as Array[Food]
	total_food_count = foods.size()
	
	var resource = Resource.new()
	
	for food in foods:
		food.get_node("Sprite2D").texture = load(Global.sprite_path_list[current_sprite])
		food.food_eaten.connect(on_food_eaten)

func on_food_eaten():
	Global.food_eaten += 1
	#print("food eaten: ", Global.food_eaten)
	
	if Global.food_eaten != total_food_count:
		return
	
	if Global.current_phase <= 3:
		Global.food_eaten = 0
		Global.current_phase += 1
		reset_positions.emit()
		change_sprites.emit()
		change_sprite()
		return
	
	get_tree().paused = true
	var puzzle_scene = preload("res://scenes/puzzle_mapa1.tscn")
	var puzzle_instance = puzzle_scene.instantiate()
	add_child(puzzle_instance)
	puzzle_instance.set_z_index(10)

func change_sprite():
	current_sprite += 1
	for food in foods:
		food.get_node("Sprite2D").texture = load(Global.sprite_path_list[current_sprite])
