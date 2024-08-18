extends Timer

var remove_queue = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_stopped() and !remove_queue.is_empty():
		start(randf_range(0.15, 0.4))


func _on_timeout():
	var item = remove_queue.pop_front()
	if item != null:
		item.remove()
