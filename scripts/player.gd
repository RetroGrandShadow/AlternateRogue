extends CharacterBody2D

class_name Player

signal health_changed

var speed: float = 150
var screen_size: Vector2
var input_dir: Vector2
var last_position: Vector2  # Variable to store the last position
var current_room: Node2D  # Variable to store the current room
@onready var animated_sprite = $AnimatedSprite2D
const ACCELERATION = 1000.0
const FRICTION = 200.0

var bullet_scene = preload("res://scenes/AnimatedBullet.tscn")
@export var max_health: int = 3
@onready var current_health: int = max_health

@onready var bullet_audio = $bullet
@onready var die_audio = $die
@onready var hurt_audio = $hurt
@onready var music_audio = $music

var did_died: bool = false

func _ready() -> void:
	music_audio.play()
	# Set player at the center of the screen
	screen_size = get_viewport_rect().size
	position = screen_size / 2

func _get_damage(attack_damage: int) -> void:
	current_health -= attack_damage
	hurt_audio.play()
	if not is_in_dungeon_room_3():
		print("CHECKING LAST POSITION")
		last_position = global_position  # Store the exact position where damage was taken
		print("LAST POSITION IS: ", last_position)
		teleport_to_marker()
	health_changed.emit(current_health)
	if current_health <= 0 and not did_died:
		die()
	else:
		if current_health > 0 and not did_died:
			hurt_audio.play()

func set_current_room(room: Node2D) -> void:
	current_room = room

func is_in_dungeon_room_3() -> bool:
	var room_node = get_node("/root/World/DungeonRoom3")
	if room_node:
		var room_bounds = calculate_room_bounds(room_node)
		return room_bounds.has_point(global_position)
	return false

func calculate_room_bounds(room: Node2D) -> Rect2:
	var min_x = INF
	var min_y = INF
	var max_x = -INF
	var max_y = -INF

	for child in room.get_children():
		if child is Node2D:
			var child_pos = child.global_position
			min_x = min(min_x, child_pos.x)
			min_y = min(min_y, child_pos.y)
			max_x = max(max_x, child_pos.x)
			max_y = max(max_y, child_pos.y)

	return Rect2(Vector2(min_x, min_y), Vector2(max_x - min_x, max_y - min_y))

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body is Enemy:
		_get_damage(1)

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.name == "Weapon":
		if current_health > 0:
			_get_damage(area.get_parent().attack_damage)
			health_changed.emit(current_health)

func die() -> void:
	did_died = true
	animated_sprite.play("die")
	if !animated_sprite.animation_finished:
		animated_sprite.stop()
	
	var end_screen_scene = preload("res://scenes/maze/Dead.tscn")
	if end_screen_scene:
		var end_screen = end_screen_scene.instantiate()
		get_tree().current_scene.add_child(end_screen)
	else:
		print("Error: Could not load EndScreen.tscn")
	#await get_tree().create_timer(1.0).timeout
	die_audio.play()

func teleport_to_marker() -> void:
	var marker = get_node("/root/World/DungeonRoom3/Marker2D")
	if marker:
		global_position = marker.global_position
	else:
		print("Error: Marker2D not found!")

func teleport_to_last_position() -> void:
	if last_position:
		global_position = last_position
		if current_room:
			current_room._on_player_detector_body_entered(self)
	else:
		print("Error: Last position not found!")

func update_animation(delta: float) -> void:
	input_dir = Input.get_vector("left", "right", "up", "down")

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

func shoot():
	bullet_audio.play()
	var bullet = bullet_scene.instantiate()
	bullet.position = position
	get_tree().current_scene.add_child(bullet)
	bullet.direction = input_dir.normalized()

func _physics_process(delta: float) -> void:
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

func _on_animated_sprite_2d_animation_looped() -> void:
	if did_died:
		animated_sprite.frame = 9
		animated_sprite.pause()
