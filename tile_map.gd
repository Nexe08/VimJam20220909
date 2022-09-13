extends TileMap
var N = 1
var E = 2
var S = 4
var W = 8

var cell_walls = {
	Vector2(1, 0): E,
	Vector2(-1, 0): W,
	Vector2(0, 1): S,
	Vector2(0, -1): N
}

var tile_size = 64
var width = 15
var height = 15

onready var running_map_generation: bool = true

onready var ss = get_viewport().get_visible_rect().size # screen size
onready var fule_source = $FuleSourcePosition
onready var fire_place = $FirePlacePosition


func _ready() -> void:
	randomize()
	tile_size = cell_size
	
	global_position = Vector2(
		ss.x / 2 - ((width * tile_size.x) / 2),
		ss.y / 2 - ((height * tile_size.y) / 2)
	)
	
	make_maze()
	


func _process(delta: float) -> void:
	if not running_map_generation:
		Global.set_fire_place_position(fire_place.global_position)
		Global.set_fule_place_position(fule_source.global_position)

func check_neighbors(cell, unvisited):
	# returns an array of unvisited neighboring cell
	var list = []
	for n in cell_walls.keys():
		if cell + n in unvisited:
			list.append(cell + n)
	return list


func make_maze():
	var unvisited = [] # array of unvisited tiles
	var stack = []
	
	# fill the map with solide color
	clear() # clear the time map
	for x in range(width):
		for y in range(height):
			unvisited.append(Vector2(x, y))
			set_cellv(Vector2(x, y), N|E|S|W)
#	var current = Vector2(0, 0) # starting point / cell of maze
	
	var current = world_to_map(Vector2(
		global_position.x + ((width * tile_size.x) - (width * tile_size.x)),
		global_position.y + ((height * tile_size.y) / 2)
	))
	unvisited.erase(current)
	
	var start_pos_of_maze_in_local = map_to_world(current)
	
	# execute recursive backtracker algorithm
	while unvisited: # loop untile every cell is not visited
		running_map_generation = true
		var neighbors = check_neighbors(current, unvisited)
		if neighbors.size() > 0: # if there is neighbore
			# choos any neighbore to next cell that will be current cell
			var next = neighbors[randi() % neighbors.size()]
			stack.append(current)
			# remove wall from the both cell
			var dir = next - current # nexe and current reffers to there respective cell positon
			var current_wall = get_cellv(current) - cell_walls[dir]
			var next_wall = get_cellv(next) - cell_walls[-dir]
			set_cellv(current, current_wall)
			set_cellv(next, next_wall)
			current = next
			unvisited.erase(current)
		elif stack:
			current = stack.pop_back()
		yield(get_tree(), "idle_frame")
	
	var last_pos_of_maze_in_local = map_to_world(current)
	fire_place.global_position = to_global(start_pos_of_maze_in_local) + Vector2(32, 32) # center
	fule_source.global_position = to_global(last_pos_of_maze_in_local) + Vector2(32, 32) # last
	
	Global.set_fire_place_position(fire_place.global_position)
	Global.set_fule_place_position(fule_source.global_position)
	
	for i in range(40):
		Global.spawn_fule(get_parent())
	
	running_map_generation = false
