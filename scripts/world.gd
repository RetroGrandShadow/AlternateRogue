extends Node

@onready var hearth_container = $CanvasLayer/HearthContainer
@onready var player = $Player

func _ready():
	hearth_container.setMaxHearts(player.max_health)
	hearth_container.updateHearts(player.current_health)
	player.health_changed.connect(hearth_container.updateHearts)
