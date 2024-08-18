extends Area2D

signal hammer

@onready var verdict_label:Label = $VerdictLabel

func _on_body_entered(body: PhysicsBody2D) -> void:
	if body.name != "hammer":
		return
	print("HAMMER FORCE: ", body.linear_velocity.length())
	if body.linear_velocity.length() > 250:
		print("HAMMERED")
		body.apply_torque_impulse(10000)
		emit_signal("hammer", self)
		find_child("AudioStreamPlayer2D").playing = true
		find_child("CPUParticles2D").emitting = true

func set_text(text: String) -> void:
	verdict_label.text = text
