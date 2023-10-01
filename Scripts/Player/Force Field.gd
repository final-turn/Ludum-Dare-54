class_name ForceField extends Node3D

signal area_changed(new_area, new_damage_reduction)

@onready var fence : MeshInstance3D = $"Fence"
@onready var force_field : MeshInstance3D = $"Force Field"
@onready var col_polygon : CollisionPolygon3D = $"Area3D/CollisionPolygon3D"
#render
var height_offset : Vector3 = Vector3(0,0.5,0)
#damage
var max_defense : float #should be set by game manager
var field_area : float
var damage_reduction : int

func set_positions(positions : Array[Vector3]):
	generate_triangle(positions)
	#generate_fence(positions)
	
	
func add_quad(posA : Vector3, posB : Vector3, height,  vertices :PackedVector3Array ):
	var c = posA + Vector3(0,height,0)
	var d = posB + Vector3(0,height,0)
	vertices.push_back(posA)
	vertices.push_back(posB)
	vertices.push_back(c)

	vertices.push_back(c)
	vertices.push_back(posB)
	vertices.push_back(d)
	return vertices

func generate_triangle(positions : Array[Vector3]):
	var vertices = PackedVector3Array()
	#vertices.push_back(positions[0] + height_offset)
	#vertices.push_back(positions[1] + height_offset)
	#vertices.push_back(positions[2]+ height_offset)
	vertices = add_quad(positions[0], positions[1], 3, vertices )
	vertices = add_quad(positions[1], positions[2], 3, vertices )
	vertices = add_quad(positions[2], positions[0], 3, vertices )
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
	
	compute_area(packed_array[0], packed_array[1], packed_array[2])



func generate_fence(positions : Array[Vector3]):
	var vertices = PackedVector3Array()
	vertices.push_back(positions[0] )
	vertices.push_back(positions[1] )
	vertices.push_back(positions[2])

	# Initialize the ArrayMesh.
	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices

	# Create the Mesh.
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	fence.mesh = arr_mesh
	


func compute_area(a : Vector2, b: Vector2, c: Vector2):
	var new_area = abs(a.x * (b.y - c.y) + b.x * (c.y - a.y) + c.x * (a.y - b.y))/2.0
	if new_area != field_area:
		compute_damage_reduction()
		area_changed.emit(new_area, damage_reduction)
		field_area = new_area
	#print("area: " + str(area))

func _on_area_3d_body_entered(body):
	if body.name == "President":
		body.set_protected(true)
		#print("President is protected")

func _on_area_3d_body_exited(body):
	if body.name == "President":
		body.set_protected(false)
		#print("President is exposed")

func compute_damage_reduction():
	# At the start of the game the triangle around the prez is 6
	var base_area = 6
	# at this stage I don't want the prez to take any damage from starter mobs
	# as the area increases the prez should reduce less damage
	var area_modifier = 1
	damage_reduction = floorf(min(1, (base_area/(field_area * area_modifier)))  * max_defense)
	#print("Field Area (%d) shields for %d" % [field_area, damage_reduction])

func _on_area_3d_area_entered(area):
	if area.name != "Area3D":
		#print("reducing %d damage" % damage_reduction)
		area.decrease_damage(damage_reduction)
