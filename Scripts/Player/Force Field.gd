class_name ForceField extends Node3D

signal area_changed(new_area, new_damage_reduction)

#@onready var damage : damagable = $"Force Field/TakeDamage"

var max_defense : float #should be set by game manager
var field_area : float
var damage_reduction : int

var edge_list : Array

func _ready():
	for n in get_children():
		edge_list.append(n)

func set_positions(positions : Array[Vector3]):
	var i = 1
	while(i <= positions.size()):
		var current_node = i % positions.size()
		var edge : ForceFieldEdge = edge_list[i - 1]
		var node_difference : Vector3 = positions[current_node] - positions[i-1]
		edge.area.scale.x = node_difference.length()
		edge.global_position = positions[i-1] + (node_difference * 0.5)
		edge.rotation.y = (1 if node_difference.z < 0 else -1) * acos(node_difference.normalized().dot(Vector3.RIGHT))
		i+=1
	#compute_area(positions[0], positions[1], positions[2])

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
	var area_modifier = 1.3
	damage_reduction = floori(min(1, (base_area/(sqrt(field_area) * area_modifier)))  * max_defense)
	#print("Field Area (%d) shields for %d" % [field_area, damage_reduction])

func _on_area_3d_area_entered(area):
	if area.name != "Area3D":
		#print("reducing %d damage" % damage_reduction)
		area.decrease_damage(damage_reduction)
		print("_on_area_3d_area_entered")
		#damage.flash_damage()
