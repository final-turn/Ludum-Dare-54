class_name ForceField extends Node3D

@onready var force_field : MeshInstance3D = $"Force Field"
@onready var col_polygon : CollisionPolygon3D = $"Area3D/CollisionPolygon3D"

var height_offset : Vector3 = Vector3(0,0.5,0)
var president_protected : bool

func set_positions(positions : Array[Vector3]):
	var vertices = PackedVector3Array()
	vertices.push_back(positions[0] + height_offset)
	vertices.push_back(positions[1] + height_offset)
	vertices.push_back(positions[2])

	# Initialize the ArrayMesh.
	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices

	# Create the Mesh.
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	force_field.mesh = arr_mesh
	
	var packed_array : PackedVector2Array = []
	for pos in positions:
		packed_array.push_back(Vector2(pos.x, pos.z))
	col_polygon.polygon = packed_array


func _on_area_3d_body_entered(body):
	if body.name == "President":
		president_protected = true
		print("President is protected")

func _on_area_3d_body_exited(body):
	
	if body.name == "President":
		president_protected = false
		print("President is exposed")
