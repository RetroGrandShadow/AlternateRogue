extends TileMap

@onready var enemy_spawner = $EnemySpawner
@onready var marker_2d = $Marker2D
@onready var player: Player = null

func _ready():
	enemy_spawner.item_scene = preload("res://scenes/SpeedItem.tscn")

func _on_player_detector_body_entered(body: Node2D) -> void:
	print("CALLED DUNGEONROOM 2 _ON_PLAYER_DETECTOR_BODY_ENTERED")
	print("player position: ", body.global_position)
	Events.room_entered.emit(self)
	if body.name == "Player":
		enemy_spawner.start_spawning(body)
		player = body
		player.set_current_room(self)

func _on_player_detector_body_exited(body: Node2D):
	print("player exited dungeonroom2 BBB")
	print(body)
	if body.name == "Player":
		enemy_spawner.stop_spawning()
	Events.room_exited.emit(self)
