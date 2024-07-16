extends Node2D

@export var room_scene: PackedScene  # PackedScene with Room node
@export var tile_map: TileMap
@export var wall_thickness: int = 2
@export var door_atlas: Vector2i = Vector2i(1, 0)  # Placeholder for door tile; replace with actual tile index
var room_instances: Array = []


var width = 0
var height = 50
func _ready():
	randomize()
	generate_rooms()
	connect_rooms()
	print_room_layout()

func generate_rooms():
	room_instances.clear()
	var room_count = 7  # Number of rooms
	for i in range(room_count):
		var room = room_scene.instantiate() as Node2D
		room.position = Vector2(width, height)
		room.wall_thickness = wall_thickness
		tile_map.add_child(room)
		room_instances.append(room)
		
		width = width + room.width *16 +40

var door_positions:Array
func connect_rooms():
	room_instances[0].width
	
	randomize()
	var door1 = Vector2(room_instances[0].width -1, randi_range(3,min(room_instances[0].height,room_instances[1].height)-3))
	
	var door2 = Vector2(randi_range(2,min(room_instances[1].width,room_instances[2].width)-2), room_instances[1].height -1)
	
	var door3 = Vector2(room_instances[2].width -1, randi_range(3,min(room_instances[2].height,room_instances[3].height)-3))
	door_positions.append(door3)

	var door4 = find_valid_pos(room_instances[2].width - 1, randi_range(3, min(room_instances[2].height, room_instances[4].height) - 3), door_positions, 4)
	door_positions.append(door4)

	var door5 = find_valid_pos(room_instances[2].width - 1, randi_range(3, min(room_instances[2].height, room_instances[5].height) - 3), door_positions, 5)
	door_positions.append(door5)
	
	var door6 = Vector2(room_instances[5].width -1, randi_range(3,min(room_instances[5].height,room_instances[6].height)-3))
	
	
	var door1_2= Vector2(1,door1.y)
	var door2_2 = Vector2(door2.x,1)
	var door3_2 = Vector2(1,door3.y)
	
	var door4_2 = Vector2(1,door4.y)
	var door5_2 = Vector2(1,door5.y)
	var door6_2 = Vector2(1,door6.y)
	
	
	room_instances[0].add_door(door1,"right",door1_2)
	room_instances[1].add_door(door2,"top",door2_2)
	room_instances[2].add_door(door3,"right",door3_2)
	room_instances[2].add_door(door4,"right",door4_2)
	room_instances[2].add_door(door5,"right",door5_2)
	room_instances[5].add_door(door6,"right",door6_2)
	
	room_instances[1].add_door(door1_2,"left",door1)
	room_instances[2].add_door(door2_2,"bottom",door2)
	room_instances[3].add_door(door3_2,"left",door3)
	room_instances[4].add_door(door4_2,"left",door4)
	room_instances[5].add_door(door5_2,"left",door5)
	room_instances[6].add_door(door6_2,"left",door6)


func find_valid_pos(init_x: int, init_y: int, existing_positions: Array, room: int) -> Vector2:
	var pos = Vector2(init_x, init_y)
	var is_valid = false
	
	while not is_valid:
		is_valid = true
		for i in existing_positions:
			if abs(i.y - pos.y) <= 2:
				pos = Vector2(room_instances[2].width - 1, randi_range(3, min(room_instances[2].height, room_instances[room].height) - 3))
				is_valid = false
				break
	return pos


func print_room_layout():
	for room in room_instances:
		print("Room Position: ", room.position)


