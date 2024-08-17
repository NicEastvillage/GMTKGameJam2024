extends Node2D

@export var stages: Array[StageData] = []
@export var current_stage_index: int = 0
@export var current_person_index: int = 0
@export var document_spawn_radius: float = 120
var polaroid: PackedScene = preload("res://prefabs/polaroid.tscn")

@onready var documents_node = $Documents
@onready var documents_personal_node = $Documents/Personal

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
	if current_stage == null or current_person == null:
		end_game()
	else:
		load_stage()

func load_stage():
	print("LOADING STAGE ", current_stage_index)
	for doc in current_stage.rule_documents:
		var inst = doc.instantiate()
		documents_node.add_child(inst)
		inst.position = Vector2(randf() * document_spawn_radius, 0).rotated(randf() * TAU)
	load_person()
	
func load_person():
	print("LOADING PERSON ", current_stage_index, ".", current_person_index, " ", current_person.name)
	# Create personal documents
	var pol = polaroid.instantiate()
	pol.find_child("Portrait").texture = current_person.portrait
	pol.find_child("Name").text = current_person.name
	documents_personal_node.add_child(pol)
	pol.position = Vector2(randf() * document_spawn_radius, 0).rotated(randf() * TAU)
	for doc in current_person.person_documents:
		var inst = doc.instantiate()
		documents_personal_node.add_child(inst)
		inst.position = Vector2(randf() * document_spawn_radius, 0).rotated(randf() * TAU)

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
