extends Area2D

@export var weight : Resource
var hovered = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and hovered:
			var new_weight = weight.instantiate()
			new_weight.global_position.x = global_position.x
			new_weight.global_position.y = global_position.y + 11
			new_weight.held = true
			get_parent().get_parent().add_child(new_weight)
			get_tree().root.get_child(0)._on_pickable_clicked(new_weight)
			get_tree().root.get_child(0)._on_weight_spawned(null)
			event.canceled = true

func _on_mouse_entered():
	hovered = true

func _on_mouse_exited():
	hovered = false


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass # Replace with function body.
