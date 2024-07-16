extends CharacterBody2D

var speed: int = 150
var screen_size: Vector2
var input_dir: Vector2
@onready var animated_sprite = $AnimatedSprite2D
const ACCELERATION = 1000.0
const FRICTION = 200.0

var bullet_scene = preload("res://scenes/AnimatedBullet.tscn")

func _ready() -> void:
	# Set player at the center of the screen
	screen_size = get_viewport_rect().size
	position = screen_size / 2

func _physics_process(delta) -> void:
	# Keyboard input
	input_dir = Input.get_vector("left", "right", "up", "down")

	# Movement and animation
	if input_dir.length() > 0:
		animated_sprite.animation = "run"
		velocity = velocity.move_toward(input_dir * speed, ACCELERATION * delta)

		if input_dir.x > 0:
			animated_sprite.flip_h = false
		else:
			animated_sprite.flip_h = true
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		animated_sprite.animation = "idle"

	move_and_slide()

	if Input.is_action_just_pressed("shoot"):
		shoot()

func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.position = position
	bullet.direction = input_dir.normalized()
	get_parent().add_child(bullet)
