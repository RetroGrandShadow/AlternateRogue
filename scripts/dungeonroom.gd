extends TileMap

# player entered the room
func _on_player_detector_body_entered(body: Node2D) -> void:
	print("dupa")
	Events.room_entered.emit(self)


func _on_player_detector_body_exited(body: Node2D) -> void:
	Events.room_exited.emit(self)
