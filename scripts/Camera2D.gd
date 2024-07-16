extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Move camera to the room the player is in
	Events.room_entered.connect(func(room):
		global_position = room.get_node("Marker2D").global_position
	)
