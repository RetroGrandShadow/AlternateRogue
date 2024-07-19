extends Node

@export var enemy_scene: PackedScene
@export var spawn_count: int = 10
@export var initial_spawn_interval: float = 3.0
@export var faster_spawn_interval: float = 1.5
@export var spawn_distance_min: float = 100.0
@export var room_size: Vector2

@onready var spawn_timer = $SpawnTimer

var enemies_spawned: int = 0
var current_spawn_interval: float
var player: Node2D

func start_spawning(player_node: Node2D):
	self.player = player_node
	current_spawn_interval = initial_spawn_interval
	enemies_spawned = 0
	spawn_timer.start(current_spawn_interval)

func stop_spawning():
	spawn_timer.stop()

func _on_SpawnTimer_timeout():
	if enemies_spawned < spawn_count:
		spawn_enemy()
		enemies_spawned += 1
		spawn_timer.start(current_spawn_interval)
	elif enemies_spawned >= spawn_count:
		# Wait for 10 seconds and then start spawning faster
		spawn_timer.start(10.0)
		current_spawn_interval = faster_spawn_interval
		enemies_spawned = 0

func spawn_enemy():
	if enemy_scene == null:
		print("Error: enemy_scene is null")
		return
	var enemy = enemy_scene.instantiate()
	var spawn_position = get_random_position()
	enemy.position = spawn_position
	add_child(enemy)
	enemy.connect("died", Callable(self, "_on_Enemy_died"))

func get_random_position() -> Vector2:
	var position = player.position
	while position.distance_to(player.position) < spawn_distance_min:
		position = Vector2(
			randf() * room_size.x,
			randf() * room_size.y
		)
	return position

func _on_Enemy_died():
	if get_tree().get_nodes_in_group("enemies").size() == 0 and spawn_timer.time_left == 0:
		# All enemies are dead, wait 10 seconds before starting faster spawn
		spawn_timer.start(10.0)
		current_spawn_interval = faster_spawn_interval
		enemies_spawned = 0
