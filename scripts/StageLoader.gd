extends Node2D

class_name StageLoader

@export var stages: Array[StageData] = []
@export var current_stage_index: int = 0
@export var current_person_index: int = 0
@export var document_spawn_radius: float = 120
@export var scream_pitch_variance = 0.4
var polaroid: PackedScene = preload("res://prefabs/polaroid.tscn")
var godly_message = preload("res://prefabs/godly_message.tscn")

@onready var documents_node = $Documents
@onready var scale_arms = $scale/arms
@onready var hammer_target = $HammerTarget
@onready var hell_sound = $HellSound
@onready var heaven_sound = $HeavenSound
@onready var rng = RandomNumberGenerator.new()

@export var grabber : StaticBody2D
@export var grabber_joint : PinJoint2D

var stagetimer : StageTimer

var spawn_effect = preload("res://prefabs/spawn_effect.tscn")
var despawn_effect = preload("res://prefabs/DocumentRemover.tscn")

var person_active : bool = false
var active_godly_message = null

func is_awaiting_user():
	return active_godly_message != null

func play_sfx(sound):
	if sound != null:
		sound.pitch_scale = rng.randf_range(1 - scream_pitch_variance, 1 + scream_pitch_variance)
		sound.playing = true

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
		push_error("Something went wrong: current stage is " + str(current_stage) + " and current person is " + str(current_person))
	stagetimer = find_child("StageTimer")
	start_game()

func start_game():
	stagetimer.add_pause(2)
	stagetimer.spawn_godly_message(
		"Welcome to your new job as the GATEKEEPER OF HEAVEN AND HELL. Or rather, welcome as their secretary.\n\n" +
		"Lesser gods as us, do most of the actual work around here, but whatever.\n\n" +
		"While drinking yesterday, one of the gods tinkered with the apes and gave some of them sentience. What a mess.\n\n" +
		"Now they want us to start sorting them into the right kind of afterlife, because sentient things can be evil, and the gods think they should be punished.\n\n" +
		"They didn't give you a mouth, so just hammer on the brass thing when you're ready."
		, "This thing?")
	stagetimer.start_stage()
	stagetimer.spawn_godly_message(
		"I'm Limfjordsporter by the way, the (lesser) god of strong beer. Nice to meet you.\n\n" +
		"I sent you the gods lists of deeds and sins. Read the material about the apes that come through, and put their weights on the correct side of the scale.\n\n" +
		"Honestly pretty easy. I'm sure even the apes could do it lol\n\n" +
		""
		, "Let's go")

func spawn_polaroid(person):
	var pol = spawn_doc(polaroid)
	pol.find_child("Portrait").texture = person.portrait
	pol.find_child("Name").text = person.name
	documents_node.add_child(pol)
	pol.add_to_group("doc_remove_on_verdict")

func spawn_personal_doc(doc):
	var inst = spawn_doc(doc)
	inst.add_to_group("doc_remove_on_verdict")
	documents_node.add_child(inst)
	return inst

func spawn_stage_doc(doc):
	var inst = spawn_doc(doc)
	documents_node.add_child(inst)
	return inst

func spawn_doc(doc):
	var inst = doc.instantiate()
	var spawn_pos = Vector2(randf() * document_spawn_radius, 0).rotated(randf() * TAU)
	inst.position = spawn_pos
	var effect = spawn_effect.instantiate()
	inst.add_child(effect)
	inst.move_child(effect, 0)
	return inst

func spawn_godly_message(txt, response):
	var inst = spawn_stage_doc(godly_message)
	inst.position = Vector2(0,0)
	inst.find_child("Label").text = txt
	active_godly_message = inst
	hammer_target.set_text(response)

func start_stage():
	print("LOADING STAGE ", current_stage_index)
	for doc in current_stage.rule_documents:
		stagetimer.spawn_stage_doc(doc)
		
	stagetimer.start_person(current_person, 6)


func start_person(person):
	print("LOADING PERSON ", person.name)
	# Create personal documents
	for doc in person.person_documents:
		stagetimer.spawn_personal_doc(doc)
	spawn_polaroid(person)
	
	stagetimer.ready_for_verdict()

func end_game():
	stagetimer.spawn_godly_message("That was all :)", "Bye :D")
	stagetimer.quit()
	# TODO: Load end screen?

func end_stage():
	# Clean up rule documents
	for child in documents_node.get_children():
		child.queue_free()  # TODO Timer
	# Next?
	current_person_index = 0
	current_stage_index += 1
	if current_stage == null or current_person == null:
		end_game()
	else:
		stagetimer.start_stage()

func end_person(sinner: bool):
	person_active = false
	# Clean up personal documents
	for node in get_tree().get_nodes_in_group("remove_on_verdict"):
		var timer = find_child("RemoveTimer")
		timer.remove_queue.append(node)
	for child in get_tree().get_nodes_in_group("doc_remove_on_verdict"):
		var effect = despawn_effect.instantiate()
		child.add_child(effect)
		effect.direction = 1
		if sinner:
			effect.direction = -1
	
	# Next?
	current_person_index += 1
	if current_person == null:
		end_stage()
	else:
		stagetimer.start_person(current_person)

func give_verdict():
	if abs(scale_arms.rotation_degrees) > 2.0:
		var sinner = scale_arms.rotation_degrees < 1.0  # Tiny bias
		if sinner:
			play_sfx(hell_sound)
		else:
			play_sfx(heaven_sound)
		# TODO: Check if correct
		if current_person.verdict_sinner == sinner: 
			stagetimer.spawn_godly_message(current_person.correct_verdict, "Next!")
		else:
			stagetimer.spawn_godly_message(current_person.wrong_verdict, "Next!")
		end_person(sinner)

var held_object = null

func _process(delta: float) -> void:
	grabber_joint.global_position = get_viewport().get_mouse_position()
	var verdict = get_verdict()
	verdict = "" if verdict == Verdict.no_verdict else "SINNER" if verdict == Verdict.sinner else "SAINT"
	if not is_awaiting_user() and person_active:
		hammer_target.set_text(verdict)

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
	if active_godly_message != null:
		active_godly_message.queue_free()
		hammer_target.set_text("")
	elif person_active:
		give_verdict()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if held_object and !event.pressed and !event.is_canceled():
			print_debug("Unhandle event: unpressed: ", event.as_text(), event.is_canceled())
			if held_object != null:
				held_object.drop(Input.get_last_mouse_velocity())
			held_object = null
			grabber_joint.node_a = NodePath()

func _on_weight_spawned(event):
	for node in get_tree().get_nodes_in_group("rigid_dragable"):
		node.connect("clicked", _on_pickable_clicked)

enum Verdict { sinner, do_gooder, no_verdict }

func get_verdict() ->  Verdict:
	if abs(scale_arms.rotation_degrees) > 2.0: 
		if scale_arms.rotation_degrees < 0:
			return Verdict.sinner
		else:
			return Verdict.do_gooder
	else:
		return Verdict.no_verdict
