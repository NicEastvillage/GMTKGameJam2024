extends Area2D

@export var weight : Resource
var hovered = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(get_child_count())
	pass

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and hovered:
			var new_weight = weight.instantiate()
			new_weight.dragging = true
			new_weight.hovered = true
			new_weight.position = get_viewport().get_mouse_position()
			get_parent().add_child(new_weight)

func _on_mouse_entered():
	hovered = true

func _on_mouse_exited():
	hovered = false


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass # Replace with function body.
