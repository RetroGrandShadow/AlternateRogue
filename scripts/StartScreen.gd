extends Control

@onready var start_button = $Button
#@onready var settings_button = $Button2

func _ready():
	start_button.connect("pressed", Callable(self, "_on_start_button_pressed"))
	#settings_button.connect("pressed", Callable(self, "_on_settings_button_pressed"))

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/world.tscn")

#func _on_settings_button_pressed():
	#get_tree().change_scene_to_file("res://scenes/SettingsScreen.tscn")
