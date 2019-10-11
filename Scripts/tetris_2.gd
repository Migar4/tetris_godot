extends TileMap

var grid = []
var static_grid = []
var grid_size : Vector2 = Vector2(16, 32)
var tile_size = get_cell_size()
var half_tile_size = tile_size / 2
var ins

var currentBlock : int = 0
var currentRotation : int = 0
var currentX : int = 0#grid_size.x / 2
var currentY : int = 0
var is_moving : bool = true
var time_out : bool = false

onready var block = preload("res://Block.tscn")

var tetromino = []

func _ready():
	randomize()
	
	tetromino.append(['o','x','o', 'o','x','o', 'o','x','o'])
	tetromino.append(['x','o','o', 'x','o','o', 'x','x','x'])
	tetromino.append(['o','o','x', 'o','o','x', 'x','x','x'])
	tetromino.append(['o','o','x', 'x','x','x', 'x','o','o'])
	tetromino.append(['x','o','o', 'x','x','x', 'o','o','x'])
	tetromino.append(['x','x','x', 'o','x','o', 'o','x','o'])
	
	
	
	for x in range(grid_size.x * grid_size.y):
		static_grid.append('o')
		grid.append('o')
	
	
	static_grid[((grid_size.y - 1) * grid_size.x) + 1] = 'x'
	static_grid[((grid_size.y - 2) * grid_size.x) + 1] = 'x'
	static_grid[((grid_size.y - 3) * grid_size.x) + 1] = 'x'
	
	currentBlock = randi() % 6
	currentRotation = randi() % 4
	
	

func _process(delta):
	
	if !is_moving:
		draw_tet()
		currentX = 0
		currentY = 0
		currentBlock = randi() % 6
		currentRotation = randi() % 4
		is_moving = true
	
	
	
	if Input.is_action_just_pressed("rotate"):
		if is_vacant(currentX, currentY):
			if currentRotation < 3:
				currentRotation += 1
			else:
				currentRotation = 0
	
	if Input.is_action_just_pressed("ui_left"):
		if is_vacant(currentX - 1, currentY):
			currentX -= 1
	
	if Input.is_action_just_pressed("ui_right"):
		if is_vacant(currentX + 1, currentY):
			currentX += 1
	
	make()
	var n = 0
	
	for y in range(grid_size.y):
		for x in range(grid_size.x):
			
			if grid[x + (grid_size.x * y)] == 'x':
				ins = block.instance() #problem might be here it keeps instancing in the same place even if there is a block present
				ins.position = map_to_world(Vector2(x,y)) + half_tile_size
				add_child(ins)
				n += 1
			
			elif grid[x + (grid_size.x * y)] == 'o':
				for node in get_tree().get_nodes_in_group("blocks"):
					if (node.position) == map_to_world(Vector2(x,y)) + half_tile_size:
						node.free()
						n -= 1
	make_grid()
	if is_vacant(currentX, currentY+1):
		if currentY < grid_size.y - 1:
			erase()
			#if !time_out:
			currentY += 1
			time_out = true
	else:
		is_moving = false


func is_vacant(posx, posy):
	
	for px in range(3):
		for py in range(3):
			var pi = rotate_tetris(currentRotation, px, py)
			var fi = (posx + px + (grid_size.x * (posy + py)))
			
			if px + posx >= 0 && px + posx < grid_size.x:
				if py + posy >= 0 && py + posy < grid_size.y:
					if (tetromino[currentBlock][pi] == 'x' and static_grid[fi] == 'x'):
#						print(pi, " ", fi)
						return false
				else:
					return false
			else:
				return false
	return true

func rotate_tetris(rot, curX : int, curY : int):
	
	var new_pos : int = 0 #the new index of the element
	
	match rot:
		0:
			new_pos = (3 * curY) + curX
		1:
			new_pos = 6 + curY - (3 * curX)
		2:
			new_pos = 8 - (3 * curY) - curX
		3:
			new_pos = 2 - curY + (3 * curX)
		
	return new_pos
	
func erase():
	for x in range(3):
		for y in range(3):
			if currentX + x < grid_size.x and currentY + y < grid_size.y and currentX + x >= 0 and currentY + y >= 0:
					if tetromino[currentBlock][rotate_tetris(currentRotation, x, y)] == 'x':
						grid[currentX + x + (grid_size.x * (currentY + y))] = 'o'

func make():
	for x in range(3):
		for y in range(3):
			if currentX + x < grid_size.x and currentY + y < grid_size.y and currentX + x >= 0 and currentY + y >= 0:
				if tetromino[currentBlock][rotate_tetris(currentRotation, x, y)] == 'x':
					grid[currentX + x + (grid_size.x * (currentY + y))] = 'x'

func count_x():
	var num = 0
	for px in grid_size.x:
		for py in grid_size.y:
			if grid[px + (grid_size.x * (py))] == 'x':
				num += 1
	print(num)

func make_grid():
	for px in range(grid_size.x):
		for py in range(grid_size.y):
			grid[px + (grid_size.x * py)] = static_grid[px + (grid_size.x * py)]

func draw_tet():
	for px in range(3):
		for py in range(3):
			if currentX + px < grid_size.x and currentY + py < grid_size.y and currentX + px >= 0 and currentY + py >= 0:
				if tetromino[currentBlock][rotate_tetris(currentRotation, px, py)] == 'x':
					static_grid[currentX + px + (grid_size.x * (currentY + py))] = 'x'

func _on_Timer_timeout():
	time_out = false
