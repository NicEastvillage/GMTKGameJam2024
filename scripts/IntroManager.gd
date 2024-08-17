extends Node

var game = load("res://scenes/main.tscn")

signal loaded

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_video_stream_player_finished():
	var node = game.instantiate()
	add_child(node)
	emit_signal("loaded")
