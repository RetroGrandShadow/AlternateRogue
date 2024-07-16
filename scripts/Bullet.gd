extends Area2D

var speed = 500
var direction = Vector2()

func _ready():
	$AnimatedBullet.play("idle")

func _process(delta):
	position += direction * speed * delta

	# remove bullet if it goes out of the screen
	if position.x < 0 or position.x > get_viewport_rect().size.x or position.y < 0 or position.y > get_viewport_rect().size.y:
		queue_free()

func _on_Area2D_body_entered(body):
	$AnimatedBullet.play("hit")
	queue_free()
