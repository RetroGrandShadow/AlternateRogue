extends TileMap

@onready var player: Player = null

# player entered the room
func _on_player_detector_body_entered(body: Node2D) -> void:
	Events.room_entered.emit(self)
	print("CALLED DUNGEONROOM 1 _ON_PLAYER_DETECTOR_BODY_ENTERED")
	print("player position: ", body.global_position)
	if body is Player:
		player = body
		player.set_current_room(self)


func _on_player_detector_body_exited(body: Node2D) -> void:
	Events.room_exited.emit(self)



@onready var goblins: Array[Node2D] = []

@export var is_last_room = false

#@export var is_first_room = false

@onready var control = $Control

@onready var control_door = $Control2

@onready var control_level = $Control3

@onready var newRoom = $newRoom

func _ready():
	# Pobierz węzeł Enemies
	var enemies_node = $Enemies
	
	if control_door != null:
		control_door.hide()
		
	if control_level != null:
		control_level.hide()
	
	# Sprawdź, czy węzeł Enemies istnieje
	if enemies_node:
		# Zainicjalizuj tablicę goblinów na podstawie dzieci węzła Enemies
		goblins = []
		for child in enemies_node.get_children():
			if child is Node2D:  # Sprawdź, czy dziecko jest typu Node2D (lub inny odpowiedni typ)
				goblins.append(child)
	else:
		print("Węzeł Enemies nie został znaleziony.")
		goblins = []
		
	check_goblins()
		

func check_goblins() -> void:
	var goblins_found = false
	#await get_tree().create_timer(1.0).timeout
	print("Sprawdzam gobliny")
	for goblin in goblins:
		if goblin and goblin.is_inside_tree():
			goblins_found = true
			print("Goblin found: ", goblin.name)
			return  # Jeśli znalazł przynajmniej jeden goblin, kończ sprawdzanie
	
	if not goblins_found:
		print("No goblins found.")
		after_no_goblis()
	else:
		print("All goblins defeated! All doors are now open.")

func remove_goblin(goblin: Node2D) -> void:
	if goblins.has(goblin):
		goblins.erase(goblin)

func after_no_goblis() -> void:
	open_all_doors()
	if is_last_room:
		open_next_level()
		show_next_level_tut()
	if control != null:
		close_tutorial()

func open_all_doors() -> void:
	if newRoom != null:
		newRoom.play()
	for child in get_children():
		if child is Area2D and child.has_method("open_door"):
			child.open_door()
	print("Doors opened.")
	
func open_next_level() -> void:
	for child in get_children():
		if child is Area2D and child.has_method("update_is_to_teleport"):
			child.update_is_to_teleport()
	print("Next level opened.")

func close_tutorial() -> void:
	control.hide()
	control_door.show()
	await get_tree().create_timer(6.0).timeout
	control_door.hide()
	
func show_next_level_tut() -> void:
	if control_level != null:
		control_level.show()
		await get_tree().create_timer(6.0).timeout
		control_level.hide()
