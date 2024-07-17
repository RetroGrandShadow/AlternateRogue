extends CharacterBody2D

class_name Player

signal health_changed

var speed: int = 150
var screen_size: Vector2
var input_dir: Vector2
@onready var animated_sprite = $AnimatedSprite2D
const ACCELERATION = 1000.0
const FRICTION = 200.0

var bullet_scene = preload("res://scenes/AnimatedBullet.tscn")
@export var max_health: int = 3
@onready var current_health: int = max_health

var did_died: bool = false

func _ready() -> void:
	# Set player at the center of the screen
	screen_size = get_viewport_rect().size
	position = screen_size / 2
	

func _get_damage(attack_damage: int) -> void:
	current_health -= attack_damage


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body is Enemy:
		_get_damage(1)
		health_changed.emit(current_health)
		# if not in dungeon already, teleport to marker

		
		
func die() -> void:
	animated_sprite.play("die")
	if !animated_sprite.animation_finished:
		animated_sprite.stop()

func update_animation(delta) -> void:
	# keybord input
	input_dir = Input.get_vector("left", "right", "up", "down")

	# Movement and animation
	if input_dir.length() > 0:
		# start animation and move player
		animated_sprite.animation = "run"
		velocity = velocity.move_toward(input_dir * speed, ACCELERATION * delta)
		
		# flip the sprite to face the direction
		if input_dir.x > 0:
			animated_sprite.flip_h = false
		else:
			animated_sprite.flip_h = true
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		animated_sprite.animation = "idle"

func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.position = position
	bullet.direction = input_dir.normalized()
	get_parent().add_child(bullet)


func _physics_process(delta) -> void:
	if current_health > 0:
		update_animation(delta)
		move_and_slide()
	else:
		if !did_died:
			die()
			did_died = true
		else:
			pass
	if Input.is_action_just_pressed("shoot"):
		shoot()

func _on_animated_sprite_2d_animation_looped():
	if did_died:
		animated_sprite.frame = 9
		animated_sprite.pause()
