extends Area2D

signal item_collected

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node2D):
	if body is Player:
		emit_signal("item_collected", body)
		queue_free()
