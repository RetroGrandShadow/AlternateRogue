extends CharacterBody2D

var speed: int = 150
var screen_size: Vector2
var input_dir: Vector2
@onready var animated_sprite = $AnimatedSprite2D


func _ready():
	# set player on the center of a screen
	screen_size = get_viewport_rect().size
	position = screen_size / 2
	

func get_input():
	# keybord input
	input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir * speed
	
func _physics_process(delta):
	# player movement
	get_input()
	move_and_slide()
	
	# get the angel
	var angel = input_dir.angle()
	angel = wrapi(int(angel), 0, 2)
	
	# animation
	if velocity.length() == 0:
		animated_sprite.animation = "idle"
	else:
		animated_sprite.animation = "run"
		if angel == 0:
			animated_sprite.flip_h = false
		else:
			animated_sprite.flip_h = true
