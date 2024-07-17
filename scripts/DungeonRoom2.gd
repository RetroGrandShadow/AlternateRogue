extends TileMap

@onready var enemy_spawner = $EnemySpawner

func _ready():
	pass

func _on_Area2D_body_entered(body: Node):
	print(body)
	if body.name == "Player":
		enemy_spawner.start_spawning(body)

func _on_Area2D_body_exited(body: Node):
	print(body)
	if body.name == "Player":
		enemy_spawner.stop_spawning()
