extends Node2D

#onready var background = $Background
onready var camera = $MainCamera
onready var fire_place = $FirePlace
onready var moving_maze_sfx = $MovingMazeSFX
onready var maze = $MapContainer/TileMap
onready var fule_progress_bar = $"%FuleProgressBar" as ProgressBar
onready var maz_is_rotation:= false

func _process(delta: float) -> void:
	
	fule_progress_bar.max_value = maze.water_partical_amount * .3
	fule_progress_bar.value = fire_place.gained_fule_partical
	
	if Input.is_action_pressed("left"):
		if not moving_maze_sfx.playing:
			moving_maze_sfx.play()
		camera.rotation_degrees = lerp(camera.rotation_degrees, camera.rotation_degrees + 10, 5 * delta)
	elif Input.is_action_pressed("right"):
		if not moving_maze_sfx.playing:
			moving_maze_sfx.play()
		camera.rotation_degrees = lerp(camera.rotation_degrees, camera.rotation_degrees - 10, 5 * delta)
	elif Input.is_action_just_pressed("Up"):
		camera.rotation_degrees = camera.rotation_degrees - 90
	elif Input.is_action_just_pressed("Down"):
		camera.rotation_degrees = camera.rotation_degrees + 90
	
	if Input.is_action_just_released("left"):
		moving_maze_sfx.stop()
	elif Input.is_action_just_released("right"):
		moving_maze_sfx.stop()
	
	var dir = deg2rad(camera.rotation_degrees + 90)
	fire_place.rotation_degrees = camera.rotation_degrees
	Physics2DServer.area_set_param(\
		get_viewport().find_world_2d().get_space(), \
		Physics2DServer.AREA_PARAM_GRAVITY_VECTOR, Vector2(cos(dir), sin(dir)))
