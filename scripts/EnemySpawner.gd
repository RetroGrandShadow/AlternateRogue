extends Node

#@export var enemy_scene: PackedScene
@export var item_scene: PackedScene
@export var spawn_count: int = 5
@export var initial_spawn_interval: float = 1.0
@export var faster_spawn_interval: float = 0.1
@export var spawn_distance_min: float = 100.0
@export var room_size: Vector2 = Vector2(880, 430)

@onready var spawn_timer = $SpawnTimer

var enemies_spawned: int = 0
var current_spawn_interval: float
var player: Node2D
var current_wave: int = 0
var wave_completed: bool = false
var active_enemies: int = 0

func _ready():
	pass

func start_spawning(player_node: Node2D):
	self.player = player_node
	current_spawn_interval = initial_spawn_interval
	enemies_spawned = 0
	current_wave = 1
	wave_completed = false
	active_enemies = 0
	spawn_timer.start(current_spawn_interval)

func stop_spawning():
	spawn_timer.stop()

func _on_SpawnTimer_timeout():
	if current_wave == 1:
		if enemies_spawned < spawn_count:
			spawn_enemy()
			enemies_spawned += 1
			spawn_timer.start(current_spawn_interval)
		elif enemies_spawned >= spawn_count and not wave_completed:
			wave_completed = true
			print("Wave 1 completed. Waiting for 5 seconds before starting Wave 2.")
			spawn_timer.start(5.0)  # Wait 5 seconds before starting the next wave
			current_wave = 2
			enemies_spawned = 0
			current_spawn_interval = faster_spawn_interval
			wave_completed = false  # Reset wave_completed for wave 2
	elif current_wave == 2:
		if enemies_spawned < spawn_count:
			spawn_enemy()
			enemies_spawned += 1
			spawn_timer.start(current_spawn_interval)
		else:
			print("Wave 2 enemies spawned. Waiting for them to be defeated.")
			wave_completed = true

func spawn_enemy():
	var enemy_scene = preload("res://scenes/purple_goblin.tscn")
	if enemy_scene == null:
		print("Error: enemy_scene is null")
		return
	var enemy = enemy_scene.instantiate() as Enemy
	var spawn_position = get_random_position()
	enemy.position = spawn_position
	
	add_child(enemy)
	enemy.activate_enemy()

	active_enemies += 1
	enemy.connect("died", Callable(self, "_on_enemy_died"))
	enemy.connect("tree_exited", Callable(self, "_on_enemy_exited"))

func _on_enemy_died():
	active_enemies -= 1
	if active_enemies <= 0 and current_wave == 2 and wave_completed:
		spawn_item()

func _on_enemy_exited(node):
	if node is Enemy:
		active_enemies -= 1
		if active_enemies <= 0 and current_wave == 2 and wave_completed:
			spawn_item()

func spawn_item():
	if item_scene == null:
		print("Error: item_scene is not assigned")
		return
	var item = item_scene.instantiate()
	var spawn_position = get_random_position()  # Or any specific position in the room
	item.position = spawn_position
	item.connect("item_collected", Callable(self, "_on_item_collected"))
	add_child(item)

func _on_item_collected(player: Player):
	player.speed *= 2
	print("Player speed doubled.")
	player.teleport_to_last_position()

func get_random_position() -> Vector2:
	var position: Vector2
	var valid_position = false

	while not valid_position:
		position = Vector2(
			randf() * room_size.x,
			randf() * room_size.y
		)
		position += Vector2(50, 50)
		if position.distance_to(player.position) >= spawn_distance_min:
			valid_position = true
	return position
