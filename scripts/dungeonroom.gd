extends TileMap

# player entered the room
func _on_player_detector_body_entered(body: Node2D) -> void:
	print("player entered dungeonroom")
	Events.room_entered.emit(self)
