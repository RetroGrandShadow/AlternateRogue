extends Control

var remap_action = ""
var remapping = false

func _ready():
	$RemapUpButton.connect("pressed", Callable(self, "_on_remap_up_pressed"))
	$RemapDownButton.connect("pressed", Callable(self, "_on_remap_down_pressed"))
	$RemapLeftButton.connect("pressed", Callable(self, "_on_remap_left_pressed"))
	$RemapRightButton.connect("pressed", Callable(self, "_on_remap_right_pressed"))
	$RemapShootButton.connect("pressed", Callable(self, "_on_remap_shoot_pressed"))
	$SaveButton.connect("pressed", Callable(self, "_on_save_pressed"))
	$CancelButton.connect("pressed", Callable(self, "_on_cancel_pressed"))

func _on_remap_up_pressed():
	start_remap("ui_up")

func _on_remap_down_pressed():
	start_remap("ui_down")

func _on_remap_left_pressed():
	start_remap("ui_left")

func _on_remap_right_pressed():
	start_remap("ui_right")

func _on_remap_shoot_pressed():
	start_remap("shoot")

func start_remap(action):
	remap_action = action
	remapping = true
	print("Press a key to remap: ", action)

func _input(event):
	if remapping and event is InputEventKey:
		if event.pressed:
			var keycode = event.keycode
			remap_action_key(remap_action, keycode)
			remapping = false

func remap_action_key(action, keycode):
	# Clear existing events for the action
	var existing_events = Input.get_action_list(action)
	for event in existing_events:
		InputMap.action_erase_event(action, event)

	# Add new event for the action
	var new_event = InputEventKey.new()
	new_event.keycode = keycode
	InputMap.action_add_event(action, new_event)
	print("Remapped ", action, " to keycode ", keycode)

func _on_save_pressed():
	get_tree().change_scene_to_file("res://scenes/StartScreen.tscn")

func _on_cancel_pressed():
	get_tree().change_scene_to_file("res://scenes/StartScreen.tscn")
