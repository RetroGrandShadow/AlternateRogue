extends CharacterBody2D

class_name Enemy

const SPEED = 100.0
const ACCELERATION = 80.0
var player_position: Vector2
var target_position: Vector2
@onready var player = get_parent().get_parent().get_node("Player")

@onready var current_health: int = 2

@onready var animation = $AnimationPlayer
@onready var sprite = $FlippableSprite
@onready var weapon = $Weapon

var attack_damage: int = 1

var flipped = false

func _get_damage(attack_damage: int) -> void:
	current_health -= attack_damage
	if current_health <= 0:
		queue_free()

func _on_hit_box_body_entered(body: Node2D) -> void:
	print("goblin got hit by something")
	if body is Bullet:
		print("it was a bullet")
		_get_damage(body.attack_damage)

func _physics_process(delta) -> void:
	player_position = player.position
	target_position = (player_position - position).normalized()
	
	
	
	if position.distance_to(player_position) > 50: 
		velocity = velocity.move_toward(target_position * SPEED, ACCELERATION * delta)
		animation.play("run")
		if target_position.x < 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
		
		if flipped != sprite.flip_h:
			weapon.scale.x *= -1
			flipped = sprite.flip_h
		move_and_slide()
		print(target_position)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION * delta)
		if abs(target_position.y) < 0.5:
			animation.play("attack")
		elif target_position.y > 0.5:
			animation.play("attack_down")
		else:
			animation.play("attack_up")

