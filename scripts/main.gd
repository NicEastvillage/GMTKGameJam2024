extends Node2D

var held_object = null
@export var grabber : StaticBody2D
@export var grabber_joint : PinJoint2D

func _ready():
	for node in get_tree().get_nodes_in_group("rigid_dragable"):
		node.connect("clicked", _on_pickable_clicked)

func _process(delta: float) -> void:
	grabber_joint.position = get_viewport().get_mouse_position()

func _on_pickable_clicked(object):
	if !held_object:
		held_object = object
		held_object.pickup()
		grabber_joint.node_a = held_object.get_path()
		grabber_joint.node_b = grabber.get_path()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if held_object and !event.pressed:
			held_object.drop(Input.get_last_mouse_velocity())
			held_object = null
			grabber_joint.node_a = NodePath()
