extends TileMap

@onready var enemy_spawner = $EnemySpawner
@onready var marker_2d = $Marker2D
	
func _on_player_detector_body_entered(body: Node2D) -> void:
	print("player entered dungeonroom2 AAA")
	Events.room_entered.emit(self)
	if body.name == "Player":
		enemy_spawner.start_spawning(body)

func _on_player_detector_body_exited(body: Node2D):
	print("player exited dungeonroom2 BBB")
	print(body)
	if body.name == "Player":
		enemy_spawner.stop_spawning()
