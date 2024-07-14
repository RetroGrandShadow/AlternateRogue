extends TileMap


func _on_player_detector_body_entered(body: Node2D) -> void:
	Events.room_entered.emit(self)
