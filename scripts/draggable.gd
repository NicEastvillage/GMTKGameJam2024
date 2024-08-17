extends CharacterBody2D
class_name Draggable

@export var can_be_weighed: bool = false
@export var weight: int = 1

var hovered: bool = false
var dragging: bool = false
var mouse_offset: Vector2
var being_weighed: bool = false

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and hovered:
			# Clicked
			dragging = true
			mouse_offset = global_position - get_viewport().get_mouse_position()
			event.canceled = true
			if being_weighed:
				being_weighed = false
				get_tree().root.get_child(0).find_child("Scale")._on_pickup(self)
		elif event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
			# Release anywhere
			if dragging:
				dragging = false
				if can_be_weighed:
					get_tree().root.get_child(0).find_child("Scale")._on_dropped(self)
	elif event is InputEventMouseMotion:
		# Mouse moved
		if dragging:
			position = event.position + mouse_offset
			print(event.position, " + ", mouse_offset)

func _on_mouse_entered():
	hovered = true

func _on_mouse_exited():
	hovered = false
