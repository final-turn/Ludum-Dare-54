extends Node3D

func _input(_event):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused

func _process(_delta):
	pass
