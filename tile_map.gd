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
var width = 25
var height = 15

func _ready() -> void:
	randomize()
	tile_size = cell_size
	make_maze()


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
	var current = Vector2(0, 0)
	unvisited.erase(current)
	
	# execute recursive backtracker algorithm
	while unvisited: # loop untile every cell is not visited
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
