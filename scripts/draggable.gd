extends CharacterBody2D

var hovered: bool = false
var dragging: bool = false
var mouse_offset: Vector2

func _ready():
	pass

func _process(delta: float) -> void:
	if dragging:
		var mpos = get_viewport().get_mouse_position()
		position = mpos + mouse_offset

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
			dragging = false

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("CLICK")
			dragging = true
			mouse_offset = position - get_viewport().get_mouse_position()
		

func _on_mouse_entered():
	print("ENTER")
	hovered = true;

func _on_mouse_exited():
	print("EXIT")
	hovered = false;
