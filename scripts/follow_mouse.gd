extends Node2D

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		# Mouse moved
		set_position(event.position)
