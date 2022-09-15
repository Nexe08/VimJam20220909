extends Node2D

onready var game_scene_path = preload("res://Game.tscn")
onready var main_menu = $CanvasLayer/Control

func enable_main_menu(value: bool):
	main_menu.visible = value
	main_menu.set_process_input(value)
	main_menu.set_process_unhandled_input(value)
	main_menu.set_process(value)
	main_menu.set_physics_process(value)


func _on_PlayButton_pressed() -> void:
	var instance = game_scene_path.instance()
	add_child(instance)
	enable_main_menu(false)


func _on_QuitButton_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
