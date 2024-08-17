extends TextureRect

var direction : Vector2 = Vector2(2, 1)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var new_pos = position + (direction * delta)
	if new_pos.x > 0:
		new_pos.x -= 640
	if new_pos.x < -640:
		new_pos.x += 640
	if new_pos.y > 0:
		new_pos.y -= 360
	if new_pos.y < -360:
		new_pos.y += 360
	set_position(new_pos)
