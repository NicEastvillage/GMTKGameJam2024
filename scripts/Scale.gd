extends Sprite2D

@onready var armsNode: Sprite2D = $Arms
@onready var leftNode: Area2D = $Arms/Left
@onready var rightNode: Area2D = $Arms/Right
@onready var leftNodeCupFoot: Node2D = $Arms/Left/CupFoot
@onready var rightNodeCupFoot: Node2D = $Arms/Right/CupFoot

@export var max_angle: float = 1
@export var weight_for_max: int = 15
@export var sigmoid_factor: float = 5

@export var sum: int = 0
var side_hovered: int = 0  # Left are sins

func _process(delta: float) -> void:
	var a = weight_to_angle(sum)
	armsNode.rotation = a
	leftNode.rotation = -a
	rightNode.rotation = -a

func weight_to_angle(w: int) -> float:
	var f = 2.0 / (1.0 + exp(-sigmoid_factor * float(w) / weight_for_max)) - 1
	return clamp(f * max_angle, -max_angle, max_angle)

func _on_dropped(draggable: Draggable):
	if side_hovered != 0:
		sum += side_hovered * draggable.weight
		draggable.being_weighed = true
		var foot = rightNodeCupFoot
		if side_hovered < 0:
			foot = leftNodeCupFoot
		draggable.reparent(foot)
		draggable.position.y = 0

func _on_pickup(draggable: Draggable):
	if draggable.get_parent() == leftNodeCupFoot:
		sum += draggable.weight
	elif draggable.get_parent() == rightNodeCupFoot:
		sum -= draggable.weight
	draggable.reparent(get_parent())

func _on_left_mouse_entered() -> void:
	side_hovered = -1

func _on_left_mouse_exited() -> void:
	side_hovered = max(0, side_hovered)

func _on_right_mouse_entered() -> void:
	side_hovered = 1

func _on_right_mouse_exited() -> void:
	side_hovered = min(0, side_hovered)
