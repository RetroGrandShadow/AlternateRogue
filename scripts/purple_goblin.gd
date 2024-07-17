extends CharacterBody2D

class_name Enemy

const SPEED = 100.0
const ACCELERATION = 80.0
var player_position: Vector2
var target_position: Vector2
@onready var player = get_parent().get_parent().get_node("Player")

@onready var current_health: int = 2

func _get_damage(attack_damage: int) -> void:
	current_health -= attack_damage


#func _on_hit_box_body_entered(body: Node2D) -> void:
	#print("dupa") # to debug 
	#if body is Player: # change Player to Bullet class when it will exist
		#_get_damage(1) # TODO in future change to bullet damage
		#if current_health <= 0:
			#queue_free()
		



func _physics_process(delta) -> void:
	
	player_position = player.position
	target_position = (player_position - position).normalized()
	
	if position.distance_to(player_position) > 3: 
		velocity = velocity.move_toward(target_position * SPEED, ACCELERATION * delta)
		move_and_slide()
	

