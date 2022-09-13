extends Node2D

onready var camera = $MainCamera
onready var maz_is_rotation:= false

func _process(delta: float) -> void:
	$Label.text = str(atan2(Physics2DServer.area_get_param(\
		get_viewport().find_world_2d().get_space(), \
		Physics2DServer.AREA_PARAM_GRAVITY_VECTOR).x, 
		Physics2DServer.area_get_param(\
		get_viewport().find_world_2d().get_space(), \
		Physics2DServer.AREA_PARAM_GRAVITY_VECTOR).y)
	)
	
	if maz_is_rotation == false:
		if Input.is_action_just_pressed("left"):
			maz_is_rotation = true
			var tween = create_tween().set_ease(Tween.EASE_OUT)
			tween.tween_property(camera, "rotation_degrees", camera.rotation_degrees - 90, .5)
			var dir = deg2rad(camera.rotation_degrees)
			Physics2DServer.area_set_param(\
				get_viewport().find_world_2d().get_space(), \
				Physics2DServer.AREA_PARAM_GRAVITY_VECTOR, Vector2(cos(dir), sin(dir)))
			yield(tween, "finished")
			maz_is_rotation = false
		elif Input.is_action_just_pressed("right"):
			maz_is_rotation = true # -------
			var tween = create_tween().set_ease(Tween.EASE_OUT)
			tween.tween_property(camera, "rotation_degrees", camera.rotation_degrees + 90, .5)
			var dir = deg2rad(camera.rotation_degrees - 90)
#			Physics2DServer.area_set_param(\
#				get_viewport().find_world_2d().get_space(), \
#				Physics2DServer.AREA_PARAM_GRAVITY_VECTOR, Vector2(cos(dir), sin(dir)))
			yield(tween, "finished") # -------
			maz_is_rotation = false # -------
