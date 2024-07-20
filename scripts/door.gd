extends Area2D

@onready var marker_2d = $Marker2D
var door_open: bool = false

# player entered the door
func _on_body_entered(body: Node2D) -> void:
	print("Dupaa"+str(door_open))
	if door_open:
		body.global_position = marker_2d.global_position

func open_door() -> void:
	door_open = true
	print("Otwieram drzwi"+name)
