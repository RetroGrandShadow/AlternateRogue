extends Area2D

@onready var marker_2d = $Marker2D


var tep_poz:Vector2


func _on_body_entered(body: Node2D) -> void:
	body.global_position = tep_poz
