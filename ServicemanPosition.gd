extends MeshInstance3D

var is_held : bool

func _on_area_3d_input_event(_camera, _event, _position, _normal, _shape_idx):
	if Input.is_action_just_pressed("click"):
		is_held = true
		print("Holding " + str(name))
	if Input.is_action_just_released("click"):
		is_held = false
		print("Released " + str(name))


func _on_area_3d_mouse_exited():
	is_held = false
	print("Released " + str(name))
