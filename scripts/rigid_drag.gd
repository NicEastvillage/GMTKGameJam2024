extends RigidBody2D

signal clicked

var held = false
var selected_sound: AudioStreamPlayer2D
var dropped_sound: AudioStreamPlayer2D
var collision_sound: AudioStreamPlayer2D
var rng = RandomNumberGenerator.new()
var pitch_variance = 0.5
var max_bongs = 3
var bongs = 0

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
			emit_signal("clicked", self)

func _physics_process(delta):
		pass

func pickup():
	bongs = 0
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
	if bongs <= max_bongs:
		play_sfx(collision_sound)
		bongs = bongs + 1
	
