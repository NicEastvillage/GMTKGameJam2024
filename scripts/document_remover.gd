extends Node2D

@export var acceleration = 3000
@export var distance_to_kill = 1000

var direction = 0
var speed = 0

func _physics_process(delta: float) -> void:
	var p = get_parent()
	if p != null:
		p.position += Vector2(direction * speed * delta, 0)
		speed += direction * acceleration * delta
		
		if p.position.length() > distance_to_kill:
			p.queue_free()
		
	else:
		speed = 0
