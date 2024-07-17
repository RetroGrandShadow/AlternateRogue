extends Area2D

class_name Bullet

var speed = 500
var direction = Vector2()
var attack_damage = 1

@onready var hit_timer = $Timer

func _ready():
	$AnimatedSprite2D.play("idle")
	hit_timer.wait_time = 0.5

func _process(delta):
	position += direction * speed * delta

	if position.x < 0 or position.x > get_viewport_rect().size.x or position.y < 0 or position.y > get_viewport_rect().size.y:
		queue_free()

func _on_Area2D_body_entered(body):
	print("Bullet hit:", body)
	if body is Enemy:
		body._get_damage(attack_damage)
	$AnimatedSprite2D.play("hit")
	hit_timer.start()

func _on_Timer_timeout():
	queue_free()
