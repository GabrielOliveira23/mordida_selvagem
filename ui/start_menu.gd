extends CanvasLayer

@onready var start_button = $"Control/StartGame"
@onready var return_button = $"Control/ReturnToMainMenu"

signal start_game
signal return_to_main_menu

func _ready():
	start_button.pressed.connect(_on_start_game)
	return_button.pressed.connect(_on_return_to_main_menu)

func _on_start_game():
	start_game.emit()

func _on_return_to_main_menu():
	return_to_main_menu.emit()
