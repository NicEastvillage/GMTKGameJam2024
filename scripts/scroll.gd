extends CharacterBody2D


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
	
var timestamp = 0
var click_limit = 200
var waiting_unpress = false

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and hovered:
			timestamp = Time.get_ticks_msec();
			waiting_unpress = true
			dragging = true
			# Clicked
			get_parent().move_child(self, len(get_parent().get_children()) - 1)
			mouse_offset = global_position - get_viewport().get_mouse_position()
			event.canceled = true
			play_sfx(selected_sound)
		elif event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
			# Release anywhere
			waiting_unpress = false
			if (Time.get_ticks_msec() - timestamp < click_limit):
				flip_visibility()
			dragging = false
			adjust_pos()
			play_sfx(dropped_sound)
	elif event is InputEventMouseMotion and hovered:
		# Mouse moved
		if waiting_unpress and Time.get_ticks_msec() - timestamp > click_limit:
			dragging = true
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
	#flip_visibility()

func _on_mouse_exited():
	hovered = false
	#flip_visibility()
	
func flip_visibility():
	find_child("shape_open").disabled = !find_child("shape_open").disabled
	find_child("shape_closed").disabled = !find_child("shape_closed").disabled
	find_child("sprite_open").visible = !find_child("sprite_open").visible
	find_child("sprite_closed").visible = !find_child("sprite_closed").visible
