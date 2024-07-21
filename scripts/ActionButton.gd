extends Button

var action: String = "shoot"

func _ready():
	set_process_unhandled_key_input(false)
	display_key()

func display_key():
	var action_events = InputMap.action_get_events(action)
	if action_events.size() > 0:
		var action_event = action_events[0]
		text = "%s" % action_event.as_text()
	else:
		text = "No key assigned"


func _on_toggled(toggled_on):
	set_process_unhandled_key_input(button_pressed)
	if (button_pressed):
		text = "..."
	else:
		display_key()

func _unhandled_key_input(event):
	remap_key(event)
	set_pressed_no_signal(false)

func remap_key(event):
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, event)
	text = "%s" % event.as_text()
