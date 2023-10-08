class_name ServicemanPosition extends Node3D

@onready var orb : Area3D = $"Area3D"
@onready var serviceman : Serviceman = $"../Serviceman"
@onready var ui : ServicemanStats = $"Stats UI"

signal on_hover(ref, is_hovered)
signal node_held(ref, is_held)

var node_index

func _on_area_3d_input_event(_camera, _event, _position, _normal, _shape_idx):
	if !get_tree().paused:
		if Input.is_action_just_pressed("click"):
			self.top_level = true
			node_held.emit(self, true)
		if Input.is_action_just_released("click"):
			self.top_level = false
			node_held.emit(self, false)

func _on_area_3d_mouse_entered():
	ui.show_ui(serviceman)

func _on_area_3d_mouse_exited():
	ui.hide()
