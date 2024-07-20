extends CharacterBody2D

class_name Enemy

signal died  # Signal to be emitted when the enemy dies

const SPEED = 100.0
const ACCELERATION = 80.0
var player_position: Vector2
var target_position: Vector2


@onready var tilemap = get_parent().get_parent()

@onready var player: Node2D = null
@onready var current_health: int = 2
@onready var animation = $AnimationPlayer
@onready var sprite = $FlippableSprite
@onready var weapon = $Weapon

var attack_damage: int = 1

var flipped = false

var activated: bool = false

func _ready():
	player = get_node("/root/World/Player")
	if player == null:
		print("Error: Player node not found")
	else:
		print("Player node found")
	Events.room_entered.connect(func(room):
		if room == tilemap:
			activated = true
		else:
			activated = false
	)
	
	Events.room_exited.connect(func(room):
		if room == tilemap:
			activated = false
	)

func _get_damage(attack_damage: int) -> void:
	current_health -= attack_damage
	if current_health <= 0:
		emit_signal("died")
		queue_free()
		_check_door()

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body is Bullet:
		_get_damage(body.attack_damage)
		
func _check_door() -> void:
	var parent_room = get_parent()
	while parent_room and not parent_room.has_method("check_goblins"):
		parent_room = parent_room.get_parent()
	
	if parent_room:
		parent_room.remove_goblin(self)
		parent_room.check_goblins()
		
		
func active_enemy(delta) -> void:
	player_position = player.global_position
	target_position = (player_position - global_position).normalized()
	
	if tilemap.get_coords_for_body_rid(player.get_node("HitBox").get_rid()) != null:
		if global_position.distance_to(player_position) > 50: 
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
		else:
			velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION * delta)
			if abs(target_position.y) < 0.5:
				animation.play("attack")
			elif target_position.y > 0.5:
				animation.play("attack_down")
			else:
				animation.play("attack_up")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION * delta)

func find_player() -> Node:
	var current_node = self
	for i in range(10):
		current_node = current_node.get_parent()
		if current_node == null:
			return null
		if current_node.has_node("Player"):
			return current_node.get_node("Player")
	return null

func _physics_process(delta) -> void:
	if activated:
		active_enemy(delta)
	else:
		animation.play("idle")


func _on_Enemy_died():
	pass # Replace with function body.
