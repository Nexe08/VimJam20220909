extends Node2D

onready var camera = $MainCamera
onready var moving_maze_sfx = $MovingMazeSFX
onready var maz_is_rotation:= false

func _process(delta: float) -> void:
	$Label.text = str(atan2(Physics2DServer.area_get_param(\
		get_viewport().find_world_2d().get_space(), \
		Physics2DServer.AREA_PARAM_GRAVITY_VECTOR).x, 
		Physics2DServer.area_get_param(\
		get_viewport().find_world_2d().get_space(), \
		Physics2DServer.AREA_PARAM_GRAVITY_VECTOR).y)
	)
	
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
	
#	if maz_is_rotation == false:
#		if Input.is_action_just_pressed("left"):
#			maz_is_rotation = true
#			var tween = create_tween().set_ease(Tween.EASE_OUT)
#			tween.tween_property(camera, "rotation_degrees", camera.rotation_degrees - 90, .5)
#			yield(tween, "finished")
#			maz_is_rotation = false
#		elif Input.is_action_just_pressed("right"):
#			maz_is_rotation = true # -------
#			var tween = create_tween().set_ease(Tween.EASE_OUT)
#			tween.tween_property(camera, "rotation_degrees", camera.rotation_degrees + 90, .5)
#			yield(tween, "finished") # -------
#			maz_is_rotation = false # -------
	
	var dir = deg2rad(camera.rotation_degrees + 90)
	Physics2DServer.area_set_param(\
		get_viewport().find_world_2d().get_space(), \
		Physics2DServer.AREA_PARAM_GRAVITY_VECTOR, Vector2(cos(dir), sin(dir)))

