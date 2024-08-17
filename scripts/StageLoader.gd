extends Node2D

@export var stages: Array[StageData] = []
@export var current_stage_index: int = 0
@export var current_person_index: int = 0
@export var document_spawn_radius: float = 120
var polaroid: PackedScene = preload("res://prefabs/polaroid.tscn")

@onready var documents_node = $Documents
@onready var documents_personal_node = $Documents/Personal

@export var grabber : StaticBody2D
@export var grabber_joint : PinJoint2D

var spawn_effect = preload("res://prefabs/spawn_effect.tscn")

var current_stage: StageData:
	get:
		if current_stage_index >= len(stages):
			return null
		return stages[current_stage_index]

var current_person: PersonData:
	get:
		if current_stage == null or current_person_index >= len(current_stage.people):
			return null
		return current_stage.people[current_person_index]

func _ready():
	for node in get_tree().get_nodes_in_group("rigid_dragable"):
		node.connect("clicked", _on_pickable_clicked)
		node.connect("hammer", _on_hammer)
	if current_stage == null or current_person == null:
		end_game()
	else:
		load_stage()

func spawn_doc(doc):
	var inst = doc.instantiate()
	var spawn_pos = Vector2(randf() * document_spawn_radius, 0).rotated(randf() * TAU)
	inst.position = spawn_pos
	var effect = spawn_effect.instantiate()
	inst.add_child(effect)
	inst.move_child(effect, 0)
	return inst

func load_stage():
	print("LOADING STAGE ", current_stage_index)
	for doc in current_stage.rule_documents:
		var inst = spawn_doc(doc)
		documents_node.add_child(inst)
	load_person()
	
func load_person():
	print("LOADING PERSON ", current_stage_index, ".", current_person_index, " ", current_person.name)
	# Create personal documents
	for doc in current_person.person_documents:
		var inst = spawn_doc(doc)
		documents_personal_node.add_child(inst)
	var pol = spawn_doc(polaroid)
	pol.find_child("Portrait").texture = current_person.portrait
	pol.find_child("Name").text = current_person.name
	documents_personal_node.add_child(pol)

func end_game():
	print("GAME OVER")
	# TODO: Load end screen?

func end_stage():
	# Clean up rule documents
	for child in documents_node.get_children():
		child.queue_free()
	
	# Next?
	current_person_index = 0
	current_stage_index += 1
	if current_stage == null or current_person:
		end_game()

func end_person():
	# Clean up personal documents
	for child in documents_personal_node.get_children():
		child.queue_free()
	
	# Next?
	current_person_index += 1
	if current_person == null:
		end_stage()
	else:
		load_person()

func give_verdict():
	# TODO: Check if correct
	
	end_person()

var held_object = null

func _process(delta: float) -> void:
	grabber_joint.global_position = get_viewport().get_mouse_position()

func _on_pickable_clicked(object):
	if !held_object:
		held_object = object
		print_debug("HELD: " + held_object.name)
		held_object.pickup()
		grabber_joint.node_a = held_object.get_path()
		grabber_joint.node_b = grabber.get_path()
		
func _on_hammer(object):
	print("Hammer recorded")
	if held_object != null:
		held_object.drop(Input.get_last_mouse_velocity())
	held_object = null
	grabber_joint.node_a = NodePath()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if held_object and !event.pressed:
			if held_object != null:
				held_object.drop(Input.get_last_mouse_velocity())
			held_object = null
			grabber_joint.node_a = NodePath()

func _on_weight_spawned(event):
	for node in get_tree().get_nodes_in_group("rigid_dragable"):
		node.connect("clicked", _on_pickable_clicked)
