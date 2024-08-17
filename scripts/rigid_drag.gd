extends RigidBody2D

signal clicked

var held = false


func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			emit_signal("clicked", self)

func _physics_process(delta):
		pass

func pickup():
	held = true

func drop(impulse=Vector2.ZERO):
	held = false
