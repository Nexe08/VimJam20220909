extends TileMap

const TILE_SIZE = 64

var width: int
var height: int

var playing := false
var temp_field

onready var screen_size = get_viewport().get_visible_rect().size

func _ready() -> void:
	width = screen_size.x / 20
	height = screen_size.y / 20
	
	var width_px = width * TILE_SIZE
	var height_px = height * TILE_SIZE
	
	var cam = $Camera2D
	
	cam.position = Vector2(width_px, height_px) / 2
	cam.zoom = Vector2(width_px, height_px) / Vector2(screen_size.x, screen_size.y)
	
	temp_field = []
	for x in range(width):
		var temp = []
		for y in range(height):
			set_cell(x, y, 0)
			temp.append(0)
		temp_field.append(temp)

func _process(_delta: float) -> void:
	_update_field()
	yield(get_tree().create_timer(.1), "timeout")
	if Input.is_action_just_pressed("ui_up"):
		var pos = (get_global_mouse_position() / TILE_SIZE).floor()
		set_cellv(pos, 1-get_cellv(pos))


func _update_field():
	# update position in temp field
	for x in range(width):
		for y in range(height):
			var live_neighbors = 0
			for x_off in [-1, 0, 1]:
				for y_off in [-1, 0, 1]:
					if x_off != y_off or x_off != 0:
						if get_cell(x + x_off, y + y_off):
							live_neighbors += 1
			
			if get_cell(x, y) == 1:
				if live_neighbor in  [2, 3]:
					pass
