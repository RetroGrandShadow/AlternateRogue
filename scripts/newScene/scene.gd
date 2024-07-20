extends Area2D


enum World {
	WORLD_3,
	WORLD_4,
	WON_GAME
}

# Exported variable to select the target world in the editor
@export var target_world: World = World.WORLD_3

func _on_body_entered(body):
	match target_world:
		World.WORLD_3:
			get_tree().change_scene_to_file("res://scenes/maze/world3.tscn")
		World.WORLD_4:
			get_tree().change_scene_to_file("res://scenes/maze/world4.tscn")
		World.WON_GAME:
			get_tree().change_scene_to_file("res://scenes/maze/gameOver.tscn")

func _on_body_exited(body):
	pass # Replace with function body.
