extends CharacterBody2D

static var greatest = null
var hovered: bool = false
var dragging: bool = false
var mouse_offset: Vector2

func _ready():
	pass

func _process(delta: float) -> void:
	if dragging:
		var mpos = get_viewport().get_mouse_position()
		position = mpos + mouse_offset
		greatest = null

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
			dragging = false

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if greatest == null or greatest.get_index() < get_index():
				if greatest != null:
					greatest.dragging = false
				dragging = true
				mouse_offset = position - get_viewport().get_mouse_position()
				greatest = self

func _on_mouse_entered():
	hovered = true;

func _on_mouse_exited():
	hovered = false;
