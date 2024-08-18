extends CharacterBody2D
class_name Draggable

@export var can_be_weighed: bool = false
@export var weight: int = 1

var hovered: bool = false
var dragging: bool = false
var mouse_offset: Vector2
var being_weighed: bool = false
var selected_sound: AudioStreamPlayer2D
var dropped_sound: AudioStreamPlayer2D
var pitch_variance = 0.5
var rng = RandomNumberGenerator.new()
var xmargin = 50
var ymargin = 35

func _ready():
	selected_sound = get_node_or_null("SelectedSound")
	dropped_sound = get_node_or_null("DroppedSound")
	
func play_sfx(sound):
	if sound != null:
		sound.pitch_scale = rng.randf_range(1 - pitch_variance, 1 + pitch_variance)
		sound.playing = true
	

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and hovered:
			# Clicked
			dragging = true
			mouse_offset = global_position - get_viewport().get_mouse_position()
			event.canceled = true
			get_parent().move_child(self, len(get_parent().get_children()) - 1)
			play_sfx(selected_sound)
		elif event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
			# Release anywhere
			if dragging:
				dragging = false
				adjust_pos()
				play_sfx(dropped_sound)
	elif event is InputEventMouseMotion:
		# Mouse moved
		if dragging:
			global_position = event.position + mouse_offset

func adjust_pos():
	if global_position.x < xmargin:
		global_position.x = xmargin
	if global_position.y < ymargin:
		global_position.y = ymargin
	if global_position.x > 640 - xmargin:
		global_position.x = 640 - xmargin
	if global_position.y > 360 - ymargin:
		global_position.y = 360 - ymargin
func _on_mouse_entered():
	hovered = true

func _on_mouse_exited():
	hovered = false
