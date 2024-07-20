extends CharacterBody2D

class_name Enemy

signal died  # Signal to be emitted when the enemy dies

const SPEED = 100.0
const ACCELERATION = 80.0
var player_position: Vector2
var target_position: Vector2

@onready var player: Node2D = null
@onready var current_health: int = 2
@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D

func _ready():
	player = get_node("/root/World/Player")
	if player == null:
		print("Error: Player node not found")
	else:
		print("Player node found")

func _get_damage(attack_damage: int) -> void:
	current_health -= attack_damage
	if current_health <= 0:
		emit_signal("died")
		queue_free()

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body is Bullet:
		_get_damage(body.attack_damage)

func _physics_process(delta) -> void:
	if player == null:
		return

	player_position = player.global_position  # Use global position
	target_position = (player_position - global_position).normalized()
	
	if position.distance_to(player_position) > 40:
		velocity = velocity.move_toward(target_position * SPEED, ACCELERATION * delta)
		animation.play("run")
		if target_position.x < 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
		move_and_slide()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION * delta)
		animation.play("attack")


func _on_Enemy_died():
	pass # Replace with function body.
