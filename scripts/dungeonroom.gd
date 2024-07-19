extends TileMap

# player entered the room
func _on_player_detector_body_entered(body: Node2D) -> void:
	print("dupa")
	Events.room_entered.emit(self)


func _on_player_detector_body_exited(body: Node2D) -> void:
	Events.room_exited.emit(self)



@onready var goblins: Array[Node2D] = []

func _ready():
	# Pobierz węzeł Enemies
	var enemies_node = $Enemies
	
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
		open_all_doors()
	else:
		print("All goblins defeated! All doors are now open.")

func remove_goblin(goblin: Node2D) -> void:
	if goblins.has(goblin):
		goblins.erase(goblin)

func open_all_doors() -> void:
	for child in get_children():
		if child is Area2D and child.has_method("open_door"):
			child.open_door()
	print("Doors opened.")
