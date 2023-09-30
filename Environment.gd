class_name ClickEnvironment extends Node3D

signal mouse_world_position(position)

func _on_area_3d_input_event(_camera, _event, pos, _normal, _shape_idx):
	if Input.is_action_pressed("click"):
		mouse_world_position.emit(pos)
	
