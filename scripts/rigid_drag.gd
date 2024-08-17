extends RigidBody2D

signal clicked

@export var default_mass = 1

var held = false
var offset : Vector2


func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			offset = position - get_viewport().get_mouse_position()
			emit_signal("clicked", self)

func _physics_process(delta):
	if held:
		pass
		#global_transform.origin = get_global_mouse_position() + offset

func pickup():
	if held:
		return
	#freeze = true
	held = true

func drop(impulse=Vector2.ZERO):
	if held:
		#freeze = false
		apply_central_impulse(impulse)
		held = false
