extends Area2D


enum World {
	Floor_2,
	Floor_3,
	WON_GAME
}

@export var target_world: World = World.Floor_2

var is_to_teleport = false

func _on_body_entered(body):
	if is_to_teleport:
		teleport_to_marker(body)

func _on_body_exited(body):
	pass # Replace with function body.
	
func update_is_to_teleport() -> void:
	is_to_teleport = true

func teleport_to_marker(body) -> void:
	print("teleport to next level")
	var marker = null
	match target_world:
		World.Floor_2:
			marker = get_node("/root/World/Floor2/Marker2D")
		World.Floor_3:
			marker = get_node("/root/World/Floor3/Marker2D")
		World.WON_GAME:
			get_tree().change_scene_to_file("res://scenes/maze/gameOver.tscn")
	if marker!=null:
		body.global_position = marker.global_position
	else:
		print("Error: Marker2D not found!")
