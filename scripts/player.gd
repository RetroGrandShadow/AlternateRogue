extends CharacterBody2D

var speed: int = 150
var screen_size: Vector2
var input_dir: Vector2
@onready var animated_sprite = $AnimatedSprite2D
const ACCELERATION = 1000.0
const FRICTION = 200.0

func _ready() -> void:
	# set player on the center of a screen
	screen_size = get_viewport_rect().size
	position = screen_size / 2
	
func _physics_process(delta) -> void:
	# keybord input
	input_dir = Input.get_vector("left", "right", "up", "down")
	
	# movement and animation
	if input_dir.length() > 0:
		animated_sprite.animation = "run"
		velocity = velocity.move_toward(input_dir * speed, ACCELERATION * delta)
		print(input_dir)

		if input_dir.x > 0:
			animated_sprite.flip_h = false
		else:
			animated_sprite.flip_h = true
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		animated_sprite.animation = "idle"
			
	move_and_slide()
