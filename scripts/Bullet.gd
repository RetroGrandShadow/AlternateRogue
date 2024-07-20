extends Area2D

class_name Bullet

var speed = 500
var direction = Vector2()
var attack_damage = 1

@onready var hit_timer = $Timer

func _ready():
	$AnimatedSprite2D.play("idle")

func _process(delta):
	position += direction * speed * delta
	
	var camera = get_viewport().get_camera_2d()
	if camera:
		var camera_position = camera.global_position
		var camera_size = get_viewport().get_visible_rect().size
		var visible_rect = Rect2(camera_position - camera_size / 2, camera_size)

		# Only queue free if the bullet is out of the camera's visible rect
		if not visible_rect.has_point(global_position):
			queue_free()
	else:
		print("No camera found")
		queue_free()

func _on_Area2D_body_entered(body):
	if body is Enemy:
		body._get_damage(attack_damage)
	$AnimatedSprite2D.play("hit")
	hit_timer.start(0.5)

func _on_timer_timeout():
	queue_free()
