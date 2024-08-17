extends CharacterBody2D

var hovered: bool = false
var dragging: bool = false
var mouse_offset: Vector2

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and hovered:
			# Clicked
			dragging = true
			mouse_offset = position - get_viewport().get_mouse_position()
			event.canceled = true
		elif event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
			# Release anywhere
			dragging = false
	elif event is InputEventMouseMotion:
		# Mouse moved
		if dragging:
			position = event.position + mouse_offset

func _on_mouse_entered():
	hovered = true

func _on_mouse_exited():
	hovered = false
