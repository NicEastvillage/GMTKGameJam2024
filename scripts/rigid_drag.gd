extends RigidBody2D

signal clicked

@export var default_mass = 1

var held = false
var offset : Vector2
var selected_sound: AudioStreamPlayer2D
var dropped_sound: AudioStreamPlayer2D
var collision_sound: AudioStreamPlayer2D
var rng = RandomNumberGenerator.new()
var pitch_variance = 0.5

func _ready():
	selected_sound = get_node_or_null("SelectedSound")
	dropped_sound = get_node_or_null("DroppedSound")
	collision_sound = get_node_or_null("CollisionSound")

func play_sfx(sound):
	if sound != null:
		sound.pitch_scale = rng.randf_range(1 - pitch_variance, 1 + pitch_variance)
		sound.playing = true

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			offset = global_position - get_viewport().get_mouse_position()
			emit_signal("clicked", self)

func _physics_process(delta):
	if held:
		pass
		#global_transform.origin = get_global_mouse_position() + offset

func pickup():
	play_sfx(selected_sound)
	if held:
		return
	#freeze = true
	held = true

func drop(impulse=Vector2.ZERO):
	if held:
		#freeze = false
		held = false
		play_sfx(dropped_sound)


func _on_body_entered(body: Node) -> void:
	play_sfx(collision_sound)
