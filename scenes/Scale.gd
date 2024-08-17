extends Sprite2D

@onready var armsNode: Sprite2D = $Arms
@onready var leftNode: Area2D = $Arms/Left
@onready var rightNode: Area2D = $Arms/Right

@export var max_angle: float = 1
@export var weight_for_max: int = 15
@export var sigmoid_factor: float = 5

var sum: int = 0

func _process(delta: float) -> void:
	var a = weight_to_angle(sum)
	armsNode.rotation = a
	leftNode.rotation = -a
	rightNode.rotation = -a
	print(a)

func weight_to_angle(w: int) -> float:
	var f = 2.0 / (1.0 + exp(-sigmoid_factor * float(w) / weight_for_max)) - 1
	return clamp(f * max_angle, -max_angle, max_angle)
