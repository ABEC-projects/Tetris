extends Node2D

const ceiling_offset = 3
const field_size: Vector2i = Vector2i(10,20+ceiling_offset)
const queue_begin_point := Vector2i(13, 1)
const storage_begin_point := Vector2i(-4, 16)
enum Tetromino {
	I, O, T, J, L, S, Z
}
const cells := {
	Tetromino.I:    [[Vector2i(-1,0), Vector2i(0,0), Vector2i(1,0), Vector2i(2,0)],
					[Vector2i(0,-1), Vector2i(0,0), Vector2i(0,1), Vector2i(0,2)],
					[Vector2i(-2,0), Vector2i(-1,0), Vector2i(0,0), Vector2i(1,0)], 
					[Vector2i(0,-2), Vector2i(0,-1), Vector2i(0,0), Vector2i(0,1)]],
	
	Tetromino.J:    [[Vector2i(-1,-1), Vector2i(-1,0), Vector2i(0,0), Vector2i(1,0)],
					[Vector2i(1,-1), Vector2i(0,-1), Vector2i(0,0), Vector2i(0,1)],
					[Vector2i(-1,0), Vector2i(0,0), Vector2i(1,0), Vector2i(1,1)], 
					[Vector2i(-1,1), Vector2i(0,1), Vector2i(0,0), Vector2i(0,-1)]],
	
	Tetromino.L:    [[Vector2i(-1,0), Vector2i(0,0), Vector2i(1,0), Vector2i(1,-1)],
					[Vector2i(0,-1), Vector2i(0,0), Vector2i(0,1), Vector2i(1,1)],
					[Vector2i(-1,1), Vector2i(-1,0), Vector2i(0,0), Vector2i(1,0)],
					[Vector2i(-1,-1), Vector2i(0,-1), Vector2i(0,0), Vector2i(0,1)]],
	
	Tetromino.O:	[[Vector2i(0,-1), Vector2i(1,-1), Vector2i(0,0), Vector2i(1,0)],
					[Vector2i(0,-1), Vector2i(1,-1), Vector2i(0,0), Vector2i(1,0)],
					[Vector2i(0,-1), Vector2i(1,-1), Vector2i(0,0), Vector2i(1,0)],
					[Vector2i(0,-1), Vector2i(1,-1), Vector2i(0,0), Vector2i(1,0)]],
	Tetromino.S: 	[[Vector2i(-1,0), Vector2i(0,0), Vector2i(0,-1), Vector2i(1,-1)],
					[Vector2i(0,-1), Vector2i(0,0), Vector2i(1,0), Vector2i(1,1)],
					[Vector2i(-1,1), Vector2i(0,1), Vector2i(0,0), Vector2i(1,0)],
					[Vector2i(-1,-1), Vector2i(-1,0), Vector2i(0,0), Vector2i(0,1)]],
	
	Tetromino.T: 	[[Vector2i(-1, 0), Vector2i(0,0), Vector2i(0,-1), Vector2i(1,0)],
					[Vector2i(0, 1), Vector2i(0,0), Vector2i(0,-1), Vector2i(1,0)],
					[Vector2i(-1, 0), Vector2i(0,0), Vector2i(0,1), Vector2i(1,0)],
					[Vector2i(0, 1), Vector2i(0,0), Vector2i(0,-1), Vector2i(-1,0)]],
	
	Tetromino.Z: 	[[Vector2i(-1,-1), Vector2i(0,-1), Vector2i(0,0), Vector2i(1,0)],
					[Vector2i(1,-1), Vector2i(1,0), Vector2i(0,0), Vector2i(0,1)],
					[Vector2i(-1,0), Vector2i(0,0), Vector2i(0,1), Vector2i(1,1)],
					[Vector2i(0,-1), Vector2i(0,0), Vector2i(-1,0), Vector2i(-1,1)]]
}
const offsets: Array = 	[[Vector2i(0,0),Vector2i(0,0),Vector2i(0,0),Vector2i(0,0),Vector2i(0,0)],
						[Vector2i(0,0),Vector2i(1,0),Vector2i(1,-1),Vector2i(0,2),Vector2i(1,2)],
						[Vector2i(0,0),Vector2i(0,0),Vector2i(0,0),Vector2i(0,0),Vector2i(0,0)],
						[Vector2i(0,0),Vector2i(-1,0),Vector2i(-1,-1),Vector2i(0,2),Vector2i(-1,2)]]

const offsetsI: Array = 	[[Vector2i(0,0),Vector2i(-1,0),Vector2i(2,0),Vector2i(-1,0),Vector2i(2,0)],
						[Vector2i(-1,0),Vector2i(0,0),Vector2i(0,0),Vector2i(0,1),Vector2i(0,-2)],
						[Vector2i(-1,1),Vector2i(1,1),Vector2i(-2,1),Vector2i(1,0),Vector2i(-2,0)],
						[Vector2i(0,1),Vector2i(0,1),Vector2i(0,1),Vector2i(0,-1),Vector2i(0,2)]]
@export var color : = {
	Tetromino.I: 1,
	Tetromino.J: 3,
	Tetromino.L: 6,
	Tetromino.O: 5,
	Tetromino.S: 2,
	Tetromino.T: 4,
	Tetromino.Z: 7
}
var field: Array = []
var new_field: Array = []
var tetromino_queque: Array
var array_with_all_tetrominos := [Tetromino.I, Tetromino.O, Tetromino.T, Tetromino.J,
								 Tetromino.L, Tetromino.S, Tetromino.Z]
var fall_prepare_time := 0.0
var rotation_prepare_time := 0.0
var rotation_delay_time := 0.0
var mevement_prepare_time := 0.0
var movement_delay_time := 0.0
var center := Vector2i(4,1)
var score := 0
var combo_counter := 0
var btb_counter := 0
var curr_tetromino: int
var tilemap := 1
var curr_rotation := 0									#0 is "0", 1 is "r", 2 is "2" and 3 is "l"
var hard_drop := false
var field_changed := true
var need_to_spawn := false
var cleaned_row := false
var inputs_storage := {
	"turn_clockwise": false,
	"turn_clockwise_just_pressed": false,
	"turn_counterclockwise": false,
	"turn_counterclockwise_just_pressed": false,
	"hard_drop": false, 
	"move_right": false,
	"move_right_just_pressed": false,
	"move_left": false,
	"move_left_just_pressed": false
}
var can_store := true
var just_rotated := false
var just_moved := false
var just_collided := false
var just_removed_row := false
var stored_tetromino := -1
@export var target_frame_rate := 120
@export var game_update_tick := 1.0/60
@export var fall_tick_period := game_update_tick*60
@export var rotation_tick_period := game_update_tick*10
@export var move_tick_period := game_update_tick*5
@export var soft_drop_speed := 20
@export var rotation_delay := game_update_tick*15
@export var movement_delay := game_update_tick*10


func rand_tetromino() -> int:
	return Tetromino.get(Tetromino.find_key(randi()%7))

func defeat():
	get_tree().paused = true

func spawn_tetromino():
	#region updating_queue
	if tetromino_queque.size() <= array_with_all_tetrominos.size():
		array_with_all_tetrominos.shuffle()
		tetromino_queque.append_array(array_with_all_tetrominos.duplicate())
	#endregion
	can_store = true
	field_changed = true
	curr_tetromino = tetromino_queque.pop_at(0)
	curr_rotation = 0
	fall_prepare_time = 0
	mevement_prepare_time = 0
	rotation_prepare_time = 0
	if curr_tetromino != Tetromino.I:
		center = Vector2i (4, 1+ceiling_offset)
	else:
		center =  Vector2i (4, ceiling_offset)
	new_field = field.duplicate(true)
	var collision: bool = false
	for i in range(4):
		if new_field[cells[curr_tetromino][0][i].x+center.x] [cells[curr_tetromino][0][i].y+center.y] == 0:
			new_field[cells[curr_tetromino][0][i].x+center.x] [cells[curr_tetromino][0][i].y+center.y] = color[curr_tetromino]
		else:
			defeat()
			collision = true
			break
	if !collision:
		field = new_field
	update_queue_visualisation()

func update_tilemap():
	for x in range(field_size.x):
		for y in range(field_size.y):
			%Tetrominos_tiles.set_cell(0, Vector2i(x, y-ceiling_offset), tilemap, Vector2i(abs(field[x][y])-1, 0))
	%Tetrominos_tiles.clear_layer(2)
	for i in range(center.y, field_size.y+1):
		var min_y := 100
		var collided := false
		for cel in cells[curr_tetromino][curr_rotation]:
			if cel.y+i == field_size.y-1 || field[cel.x+center.x][cel.y+i+1] < 0:
				collided = true
				min_y = min(min_y, cel.y+i)
		if collided:
			for cel in cells[curr_tetromino][curr_rotation]:
				%Tetrominos_tiles.set_cell	(2, Vector2i(cel.x+center.x, cel.y+i-ceiling_offset), 
											tilemap, Vector2i(7, 0))
			break

func update_queue_visualisation():
	%Tetrominos_tiles.clear_layer(1)
	for delX in range(4):
		for delY in range(30):
			%Tetrominos_tiles.set_cell	(1, queue_begin_point+Vector2i(delX, delY),
										 tilemap, Vector2i(-2, 0))
	for i in range(7):
		for cell_to_draw in cells[tetromino_queque[i]][0]:
			%Tetrominos_tiles.set_cell	(1, queue_begin_point+Vector2i(cell_to_draw.x, cell_to_draw.y+i*3),
										 tilemap, Vector2i(abs(color[tetromino_queque[i]])-1, 0))
	if stored_tetromino != -1:
		for i in cells[stored_tetromino][0]:
			%Tetrominos_tiles.set_cell	(1, storage_begin_point+Vector2i(i.x, i.y),
										 tilemap, Vector2i(color[stored_tetromino]-1, 0))

func _ready():
	array_with_all_tetrominos.shuffle()
	tetromino_queque.append_array(array_with_all_tetrominos.duplicate())
	array_with_all_tetrominos.shuffle()
	tetromino_queque.append_array(array_with_all_tetrominos.duplicate())
	update_queue_visualisation()
	Engine.max_fps = target_frame_rate
	for x in range(field_size.x):
		field.append([])
		for y in range(field_size.y+ceiling_offset):
			field[x].append(0)
	spawn_tetromino()

func remove_full_rows():
	if just_collided:
		just_collided = false
		var counter := 0
		for y in range(field_size.y):
			var full_row: bool = true
			for x in range(field_size.x):
				if field[x][y] >= 0:
					full_row = false
					break
			if full_row:
				counter += 1
				field_changed = true
				for del in range(field_size.x):
					field[del][y] = 0
				for y1 in range(y-1, -1, -1):
					for x1 in range(field_size.x):
						if field[x1][y1] < 0:
							field[x1][y1+1] = field[x1][y1]
							field[x1][y1] = 0
		if counter > 0:
			var add := 0
			#region Regular
			match counter:
				1:
					add += 100
				2:
					add += 300
				3:
					add += 500
				4:
					add += 800
			#endregion
			#region Combo
			if just_removed_row:
				combo_counter += 1
				add += combo_counter*50
			else:
				combo_counter = 0
			#endregion
			#region BtB
			if counter == 4:
				%WowYouGotTetris.play()
				if btb_counter > 0:
					add *= 1.5
				btb_counter += 1
			else:
				btb_counter = 0
			#endregion
			score += add
			%UI.change_score(score)
			just_removed_row = true
		else:
			just_removed_row = false

func dropTetromino():
	while fall_prepare_time >= fall_tick_period:
		fall_prepare_time -= fall_tick_period
		#region FallingAndCollisionCheck
		new_field = field.duplicate(true)
		var collision: bool = false
		for x in range(field_size.x-1, -1, -1):
			if collision:
				break
			for y in range(field_size.y-1, -1, -1):
				if new_field[x][y] > 0:
					if y+1 < field_size.y && new_field[x][y+1] == 0:
						new_field[x][y+1] = new_field[x][y]
						new_field[x][y] = 0
					else:
						collision = true
						break
		#endregion
		#region IfCollision
		if collision:
			for x in range(field_size.x-1, -1, -1):
				for y in range(field_size.y-1, -1, -1):
					if field[x][y] > 0:
						field[x][y] = -field[x][y]
			inputs_storage["hard_drop"] = false
			collision = false
			need_to_spawn = true
			just_collided = true
			fall_prepare_time = 0
		#endregion
		#region IfNoCollision
		else:
			center.y += 1
			field.assign(new_field.duplicate())
		#endregion
		field_changed = true

func rotateTetromino():
	var is_first_tick: bool = false
	if (inputs_storage["turn_clockwise_just_pressed"] || inputs_storage["turn_counterclockwise_just_pressed"]):
		rotation_prepare_time = rotation_tick_period
		is_first_tick = true
		rotation_delay_time = 0
	
	if rotation_delay_time < rotation_delay:
		rotation_prepare_time = min(rotation_prepare_time, rotation_tick_period)
	
	if (rotation_prepare_time-rotation_tick_period >= 0 && rotation_delay_time >= rotation_delay) || is_first_tick:
		var collision: bool = false
		rotation_prepare_time -= rotation_tick_period
		new_field = field.duplicate(true)
		var new_rotation = curr_rotation
		if (inputs_storage["turn_clockwise"] && !just_rotated) || (Input.is_action_pressed("turn_clockwise") && just_rotated):
			new_rotation += 1
		elif (inputs_storage["turn_counterclockwise"] && !just_rotated) || (Input.is_action_pressed("turn_counterclockwise") && just_rotated):
			new_rotation -= 1
		
		if new_rotation == -1:
			new_rotation = 3
		elif new_rotation == 4:
			new_rotation = 0
		if new_rotation != curr_rotation:
			for del: Vector2i in cells[curr_tetromino][curr_rotation]:
				new_field[center.x+del.x][center.y+del.y] = 0
			var curr_offset := 0
			var offset_to_use: Vector2i
			while curr_offset < 4:
				collision = false
				if curr_tetromino == Tetromino.I:
					offset_to_use = offsetsI[curr_rotation][curr_offset]-offsetsI[new_rotation][curr_offset]
				else:
					offset_to_use = offsets[curr_rotation][curr_offset]-offsets[new_rotation][curr_offset]
				for add: Vector2i in cells[curr_tetromino][new_rotation]:
					if (center.x+add.x+offset_to_use.x >=0 && center.x+add.x+offset_to_use.x <field_size.x && center.y+add.y >= 0 
							&& center.y+add.y+offset_to_use.y < field_size.y+offset_to_use.y && center.y+add.y+offset_to_use.y >= 0
							&& new_field[center.x+add.x+offset_to_use.x][center.y+add.y+offset_to_use.y] == 0):
						pass
					else:
						collision = true
				if collision == false:
					break
				curr_offset += 1
			
			if curr_offset != 4:
				for add: Vector2i in cells[curr_tetromino][new_rotation]:
						new_field[center.x+add.x+offset_to_use.x][center.y+add.y+offset_to_use.y] = color[curr_tetromino]
				center += offset_to_use
				field = new_field
				curr_rotation = new_rotation
				field_changed = true
				just_rotated = true
		else:
			just_rotated = false
		inputs_storage["turn_clockwise"] = false
		inputs_storage["turn_counterclockwise"] = false
		inputs_storage["turn_clockwise_just_pressed"] = false
		inputs_storage["turn_counterclockwise_just_pressed"] = false

func moveTetromino():
	var is_first_tick: bool = false
	if inputs_storage["move_right_just_pressed"] || inputs_storage["move_left_just_pressed"]:
		mevement_prepare_time = move_tick_period
		is_first_tick = true
		movement_delay_time = 0
	
	if movement_delay_time < movement_delay:
		mevement_prepare_time = min(mevement_prepare_time, move_tick_period)
	
	if (mevement_prepare_time >= move_tick_period && movement_delay_time >= movement_delay) || is_first_tick:
		var direction: int = 0
		var rightRangeForX: Array
		if (inputs_storage["move_right"] && !just_moved) || (Input.is_action_pressed("move_right") && just_moved):
			direction = 1
			rightRangeForX = range(field_size.x-1, -1, -1)
			mevement_prepare_time -= move_tick_period
		elif (inputs_storage["move_left"] && !just_moved) || (Input.is_action_pressed("move_left") && just_moved):
			direction = -1
			rightRangeForX = range(0, field_size.x, 1)
			mevement_prepare_time -= move_tick_period
		if direction != 0:
			just_moved = true
			var collision: bool = false
			var toMove: Array = []
			for y in range(field_size.y-1, -1, -1):
				if collision:
					break
				for x in rightRangeForX:
					if field[x][y]>0:
						if x+direction >= 0 && x+direction <= field_size.x-1 && (field[x+direction][y] == 0 
								|| field[x+direction][y] == color[curr_tetromino]):
							toMove.push_back(Vector2i(x, y))
						else:
							collision = true
							break
			if !collision:
				center.x += direction
				for i in range(toMove.size()):
					field[toMove[i].x][toMove[i].y] = 0
				for i in range(toMove.size()):
					field[toMove[i].x+direction][toMove[i].y] = color[curr_tetromino]
				field_changed = true
		else:
			mevement_prepare_time = move_tick_period
			just_moved = false
		inputs_storage["move_right"] = false
		inputs_storage["move_left"] = false
		inputs_storage["move_right_just_pressed"] = false
		inputs_storage["move_left_just_pressed"] = false

func get_inputs():
	
	if Input.is_action_pressed("move_left"):
		inputs_storage["move_left"] = true
	if Input.is_action_just_pressed("move_left"):
		inputs_storage["move_left_just_pressed"] = true
	
	if Input.is_action_pressed("move_right"):
		inputs_storage["move_right"] = true
	if Input.is_action_just_pressed("move_right"):
		inputs_storage["move_right_just_pressed"] = true
	
	if Input.is_action_pressed("turn_clockwise"):
		inputs_storage["turn_clockwise"] = true
	if Input.is_action_just_pressed("turn_clockwise"):
		inputs_storage["turn_clockwise_just_pressed"] = true
	
	if Input.is_action_pressed("turn_counterclockwise"):
		inputs_storage["turn_counterclockwise"] = true
	if Input.is_action_just_pressed("turn_counterclockwise"):
		inputs_storage["turn_counterclockwise_just_pressed"] = true


func store_tetromino():
	if Input.is_action_just_pressed("store") && can_store:
		if stored_tetromino != -1:
			var buff
			buff = stored_tetromino
			stored_tetromino = curr_tetromino
			for del in cells[curr_tetromino][curr_rotation]:
				field[del.x+center.x][del.y+center.y] = 0
			tetromino_queque.push_front(buff)
			spawn_tetromino()
		else:
			stored_tetromino = curr_tetromino
			for del in cells[curr_tetromino][curr_rotation]:
				field[del.x+center.x][del.y+center.y] = 0
			spawn_tetromino()
		can_store = false
		update_queue_visualisation()

func _process(_delta):
	get_inputs()
	if need_to_spawn:
		spawn_tetromino()
		need_to_spawn = false
	
	if Input.is_action_just_pressed("hard_drop"):
		hard_drop = true
		fall_prepare_time = fall_tick_period*100
	
	if Input.is_action_pressed("soft_drop") == true:
		fall_prepare_time += _delta*soft_drop_speed
	else:
		fall_prepare_time += _delta
	rotation_prepare_time += _delta
	rotation_delay_time += _delta
	mevement_prepare_time += _delta
	movement_delay_time += _delta
	
	moveTetromino()
	rotateTetromino()
	dropTetromino()
	remove_full_rows()
	store_tetromino()
	
	if field_changed:
		update_tilemap()
	field_changed = false


func _on_ui_toggle_pause(paused):
	get_tree().paused = paused
