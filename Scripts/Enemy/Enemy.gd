class_name Enemy extends Node3D

@export var movespeed : float
var president : President

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at(president.global_position, Vector3.UP)
	global_position.move_toward(president.global_position, delta * movespeed)
