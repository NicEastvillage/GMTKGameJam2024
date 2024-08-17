extends RigidBody2D

signal clicked
signal hammer

var held = false

var default_pos : Vector2
var default_angle 
var max_vel = 10

var pause_count : float
var pause_limit = 1

func _ready() -> void:
	default_pos = global_position
	default_angle = global_rotation

func _process(delta: float) -> void:
	#if not held:
	var x_diff = default_pos.x - global_position.x
	var y_diff = default_pos.y - global_position.y
	var dist = global_position.distance_to(default_pos) 
	var direction = Vector2(x_diff, y_diff)
	direction = direction.normalized()
	linear_velocity = direction * (lerp(dist, 0.0, 0.5) * max_vel)
	angular_velocity = lerp(default_angle - global_rotation, 0.0, 0.5) * max_vel

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
