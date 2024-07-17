extends HBoxContainer

@onready var HeartClass = preload("res://scenes/heart.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func setMaxHearts(max: int) -> void:
	for i in range(max):
		var heart = HeartClass.instantiate()
		add_child(heart)
		
func updateHearts(current_health: int) -> void:
	var hearts = get_children()
	
	for i in range(current_health):
		hearts[i].update(true)
		
	for i in range(current_health, hearts.size()):
		hearts[i].update(false)
