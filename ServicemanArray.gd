class_name ServicemanArray extends Node3D

var perimeter_nodes : Array[ServicemanPosition]

var held_node : ServicemanPosition

func _ready():
	for N in get_children():
		var child : ServicemanPosition = N
		child.node_held.connect(on_node_held)
		perimeter_nodes.append(child)

func on_mouse_world_position(pos):
	if held_node != null:
		print("Holding " + str(held_node) + " at " + str(pos))
		held_node.position = Vector3(pos.x, 0.7, pos.z)

func on_node_held(target, is_held):
	held_node = target if is_held else null
