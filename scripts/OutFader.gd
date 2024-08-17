extends ColorRect

var fading : bool = false
var speed : float = 0.005

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if color.a <= 0:
		queue_free()
	if fading:
		color.a -= speed

func _on_fade_start():
	fading = true
