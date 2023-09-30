class_name ServicemanPosition extends MeshInstance3D

@onready var orb : Area3D = $"Area3D"

signal node_held(ref, is_held)

func _on_area_3d_input_event(_camera, _event, _position, _normal, _shape_idx):
	if Input.is_action_just_pressed("click"):
		self.top_level = true
		node_held.emit(self, true)
	if Input.is_action_just_released("click"):
		self.top_level = false
		node_held.emit(self, false)
