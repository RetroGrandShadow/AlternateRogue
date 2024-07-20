extends Node

@export var enemy_scene: PackedScene
@export var spawn_count: int = 5
@export var initial_spawn_interval: float = 1.0
@export var faster_spawn_interval: float = 0.1
@export var spawn_distance_min: float = 100.0
@export var room_size: Vector2  # TODO: Dynamically calculate room size

@onready var spawn_timer = $SpawnTimer

var enemies_spawned: int = 0
var current_spawn_interval: float
var player: Node2D
var current_wave: int = 0
var wave_completed: bool = false

func _ready():
	if enemy_scene == null:
		print("Error: enemy_scene is not assigned")
	else:
		print("enemy_scene assigned successfully")

func start_spawning(player_node: Node2D):
	self.player = player_node
	current_spawn_interval = initial_spawn_interval
	enemies_spawned = 0
	current_wave = 1
	wave_completed = false
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
	elif current_wave == 2:
		if enemies_spawned < spawn_count:
			spawn_enemy()
			enemies_spawned += 1
			spawn_timer.start(current_spawn_interval)
		else:
			stop_spawning()
			print("All waves completed.")

func spawn_enemy():
	if enemy_scene == null:
		print("Error: enemy_scene is null")
		return
	var enemy = enemy_scene.instantiate()
	var spawn_position = get_random_position()
	enemy.position = spawn_position
	add_child(enemy)

func get_random_position() -> Vector2:
	var position: Vector2
	var valid_position = false

	while not valid_position:
		position = Vector2(
			randf() * room_size.x,
			randf() * room_size.y
		)
		if position.distance_to(player.position) >= spawn_distance_min:
			valid_position = true
	return position
