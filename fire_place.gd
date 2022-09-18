extends Area2D

export var gained_fule_partical: int = 0


func _process(delta: float) -> void:
	global_position = Global.fire_place_position


func _on_FirePlace_body_entered(body: Node) -> void:
	if body.is_in_group("WaterPartical"):
		body.call_deferred("queue_free")
		gained_fule_partical += 1
