extends Node
# global

var fire_place_position: Vector2 setget set_fire_place_position
var fule_place_position: Vector2 setget set_fule_place_position

onready var liquid_path = preload("res://WaterPartical.tscn")


func spawn_fule(parent: Node):
	var instance = liquid_path.instance()
	parent.call_deferred("add_child", instance)


# SETGET METHODE ---------------------------------------
func set_fire_place_position(value: Vector2):
	fire_place_position = value


func set_fule_place_position(value: Vector2):
	fule_place_position = value
