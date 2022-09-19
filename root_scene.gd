extends Node2D

onready var game_scene_path = preload("res://Game.tscn")
onready var main_menu = $CanvasLayer/MainMenu
onready var win_screen = $CanvasLayer/WinScreen


func _ready() -> void:
	enable_win_screen(false)
	enable_main_menu(true)
	Global.connect("reset_game", self, "reset_game")
	Global.connect("finish_game", self, "finish_game")


func enable_main_menu(value: bool):
	main_menu.visible = value
	main_menu.set_process_input(value)
	main_menu.set_process_unhandled_input(value)
	main_menu.set_process(value)
	main_menu.set_physics_process(value)


func enable_win_screen(value: bool):
	win_screen.visible = value
	win_screen.set_process_input(value)
	win_screen.set_process_unhandled_input(value)
	win_screen.set_process(value)
	win_screen.set_physics_process(value)


func start_game():
	var instance = game_scene_path.instance()
	add_child(instance)
	enable_main_menu(false)
	enable_win_screen(false)

# signal connections
func _on_PlayButton_pressed() -> void:
	start_game()


func _on_QuitButton_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.


func reset_game():
	start_game()


func finish_game():
	enable_main_menu(false)
	enable_win_screen(true)


func _on_winScreen_PlayButton_pressed() -> void:
	start_game()


func _on_ButtonBack_pressed() -> void:
	enable_win_screen(false)
	enable_main_menu(true)
