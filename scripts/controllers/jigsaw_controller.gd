extends Node

@export var chain: ChainTheme
@export var success_color: Color
@export var failed_color: Color

@onready var answer_button = $Button

var draggables: Array[Draggable]
var dropables: Array[Dropable]
var index: int
var correct: int
var points: int

var current_chain: ChainProblem:
	get:
		return chain.theme[index]

func _ready():
	points = 0
	
	for dropable in $Dropable.get_children():
		dropables.append(dropable)
	
	for dragable in $Draggable.get_children():
		draggables.append(dragable)
	
	load_problem()
	answer_button.pressed.connect(_on_answer.bind(answer_button))

func load_problem() -> void:
	if index >= chain.theme.size():
		# game_over()
		return
	
	var shuffled_drags = draggables.duplicate()
	shuffled_drags.shuffle()
	
	for i in range(draggables.size()):
		shuffled_drags[i].name = current_chain.correct_chain[i]
		var texture_path = current_chain.texture_paths[i]
		var texture = load(texture_path) as Texture2D
		
		if texture:
			shuffled_drags[i].texture = texture
		else:
			printerr("Falha ao carregar a textura: ", texture_path)
	
	draggables = shuffled_drags

func _on_answer(button: Button) -> void:
	print('tentou')
	if checkOrder():
		print('parabens')
		button.modulate = success_color
	else:
		print('erroooou')
		button.modulate = failed_color

func checkOrder() -> bool:
	for i in range(dropables.size()):
		print(dropables[i].occupied_by)
		print(current_chain.correct_chain[i])
		if dropables[i].occupied_by != current_chain.correct_chain[i]:
			return false
	
	return true

#func game_over() -> void:
	#$Container/QuizBox.hide()
	#$Container/EndedQuiz/Points.text = str("Pontuação: ", points, "/", quiz.theme.size())
	#$Container/EndedQuiz.show()
