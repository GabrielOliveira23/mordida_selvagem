extends Node

var total_food_count
var foods_eaten = 0

func _ready():
	var foods = self.get_children() as Array[Food]
	total_food_count = foods.size()
	
	for food in foods:
		food.food_eaten.connect(on_food_eaten)

func on_food_eaten():
	foods_eaten += 1
	
	if foods_eaten == total_food_count:
		get_tree().paused = true
		var puzzle_scene = preload("res://scenes/puzzle_mapa1.tscn")
		var puzzle_instance = puzzle_scene.instantiate()
		add_child(puzzle_instance)
		puzzle_instance.set_z_index(10)
