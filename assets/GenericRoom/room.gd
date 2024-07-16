extends Node2D
@export var tile_map1: TileMap
@export var door_scene: PackedScene 
@export var noise_height_text: NoiseTexture2D

var noise: Noise

var width: int
var height: int


@onready var tile_map = $TileMap

var source_id = 1 
var land_atlas = [Vector2i(0,0),Vector2i(0,4),Vector2i(1,4),Vector2i(2,4),Vector2i(3,4),Vector2i(4,4),Vector2i(5,4)]
var barier_atlas = [Vector2i(3,3),Vector2i(0,5)]
var wall_atlas = Vector2(10,4)
var door_atlas = [Vector2(10,0),Vector2(11,0)]


var min_sizeH: int = 25
var max_sizeH: int = 40

var min_sizeW: int = 30
var max_sizeW: int = 60

var wall_thickness: int = 2

# Lista pozycji drzwi (współrzędne w tileach)
var door_positions: Array = []

func _ready():
	# Inicjalizacja seeda dla losowego generowania
	randomize()  # Inicjalizuje generator liczb losowych
	var seed = randi()  # Generuje losowy seed
	print("Seed: ", seed)  # Opcjonalnie, wyświetl seed w konsoli
	
		# Ustawienie losowych szerokości i wysokości
	width = randi_range(min_sizeW, max_sizeW)
	height = randi_range(min_sizeH, max_sizeH)
	
	# Inicjalizacja szumu z ustawionym seedem
	noise = noise_height_text.noise
	noise.seed = seed  # Ustawienie seeda
	
	#add_door(Vector2(randi_range(0, width), wall_thickness-1))
	
	generate_world()
	draw_walls_and_doors()
	


# Zdefiniuj zmienne graniczne na początku skryptu
var land_thresholds = [-0.25,-0.20, 0.0, 0.2,0.3, 0.4, 0.6]
var barrier_thresholds = [-0.5]

func generate_world():
	for x in range(width):
		for y in range (height):
			var noise_val = noise.get_noise_2d(x,y)
			var tile_position = Vector2(x, y)
			add(tile_position)
			# Przypisz wartości `noise_val` do odpowiednich przedziałów i ustaw komórki mapy
			if noise_val >= land_thresholds[0]:
				if noise_val <= land_thresholds[1]:
					tile_map.set_cell(0, tile_position, source_id, land_atlas[0])
				elif noise_val <= land_thresholds[2]:
					tile_map.set_cell(0, tile_position, source_id, land_atlas[1])
				elif noise_val <= land_thresholds[3]:
					tile_map.set_cell(0, tile_position, source_id, land_atlas[2])
				elif noise_val <= land_thresholds[4]:
					tile_map.set_cell(0, tile_position, source_id, land_atlas[3])
				elif noise_val <= land_thresholds[5]:
					tile_map.set_cell(0, tile_position, source_id, land_atlas[4])
				else:
					tile_map.set_cell(0, tile_position, source_id, land_atlas[5])
			elif noise_val < land_thresholds[0]:
				if noise_val > barrier_thresholds[0]:
					tile_map.set_cell(0, tile_position, source_id, barier_atlas[0])
				else:
					tile_map.set_cell(0, tile_position, source_id, barier_atlas[1])

func add_collider(position: Vector2):
	#var area = Area2D.new()
	#var collision_shape = CollisionShape2D.new()
	#var rectangle_shape = RectangleShape2D.new()
	#
	#collision_shape.shape = rectangle_shape
	#area.add_child(collision_shape)
	#
	#area.collision_priority = 1
	#area.collision_mask = 4
	#area.collision_layer = 0
	#
	#area.position = position
	#add_child(area)
	pass
	
func add_door_collider(position: Vector2,tep_poz):

	var door = door_scene.instantiate() as Node2D
	
	door.position=position
	door.tep_poz = tep_poz
	tile_map1.add_child(door)

func add(position: Vector2):
	#var area = Area2D.new()
	#var collision_shape = CollisionShape2D.new()
	#var rectangle_shape = RectangleShape2D.new()
	#
	#collision_shape.shape = rectangle_shape
	#area.add_child(collision_shape)
	#
	#area.collision_priority= 1
	#area.collision_mask = 1
	#area.collision_layer = 0
	#
	#area.position = position
	#add_child(area)
	pass

# Funkcja do rysowania ścian wokół całego obszaru
func draw_walls_and_doors():
	
	for i in range(wall_thickness):
		for x in range(width-i+1):
			for y in [i,height-i]:
				var tile_position = Vector2(x, y)
				tile_map.set_cell(0, tile_position, source_id, wall_atlas)
				add_collider(tile_position)

		for y in range(height-i):
			for x in [i, width-i]:
				var tile_position = Vector2(x, y)
				tile_map.set_cell(0, tile_position, source_id, wall_atlas)
				add_collider(tile_position)
				

# Funkcja do dodawania drzwi z obsługą obrotu tekstury
func add_door(position: Vector2, orientation: String,tep_poz:Vector2):
	add_door_collider(position,tep_poz)
	if orientation == "top":
		tile_map.set_cell(0, position, source_id, door_atlas[0])
		tile_map.set_cell(0, Vector2(position.x + 1, position.y), source_id, door_atlas[1])
	elif orientation == "bottom":
		tile_map.set_cell(0, position, source_id, door_atlas[0])
		tile_map.set_cell(0, Vector2(position.x + 1, position.y), source_id, door_atlas[1])
	elif orientation == "left":
		tile_map.set_cell(0, position, source_id, door_atlas[0])
		tile_map.set_cell(0, Vector2(position.x, position.y + 1), source_id, door_atlas[1])
	elif orientation == "right":
		tile_map.set_cell(0, position, source_id, door_atlas[0])
		tile_map.set_cell(0, Vector2(position.x, position.y + 1), source_id, door_atlas[1])
