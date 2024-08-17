extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	find_child("Particles").emitting = true


func _on_cpu_particles_2d_finished():
	queue_free()
