extends Control

@onready var start_button = $Button

func _ready():
	start_button.connect("pressed", Callable(self, "_on_start_button_pressed"))

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/world.tscn")
