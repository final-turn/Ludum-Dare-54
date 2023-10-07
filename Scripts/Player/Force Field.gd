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

var moving_node_index = 0
func override_edge_label(held_node : ServicemanPosition, is_held : bool):
	edge_list[moving_node_index].show_defense_override = false
	edge_list[(moving_node_index - 1 + edge_list.size()) % edge_list.size()].show_defense_override = false
	
	moving_node_index = held_node.node_index if is_held else -1
	
	edge_list[moving_node_index].show_defense_override = is_held
	edge_list[(moving_node_index - 1 + edge_list.size()) % edge_list.size()].show_defense_override = is_held

func set_positions(positions : Array[Serviceman]):
	var i = 1
	while(i <= positions.size()):
		var a_index = i % positions.size()
		var b_index = i-1
		var edge : ForceFieldEdge = edge_list[i - 1]
		var agent_a : Serviceman = positions[a_index]
		var agent_b : Serviceman = positions[b_index]
		var node_difference : Vector3 = agent_a.global_position - agent_b.global_position
		
		edge.agent_defense = agent_a.defense + agent_b.defense
		edge.area.scale.x = node_difference.length()
		edge.global_position = agent_b.global_position + (node_difference * 0.5)
		edge.rotation.y = (1 if node_difference.z < 0 else -1) * acos(node_difference.normalized().dot(Vector3.RIGHT))
		
		if edge.show_defense_override:
			var a = agent_a.global_position
			if(a_index == moving_node_index):
				a = agent_a.target_position.global_position
			var b = agent_b.global_position
			if(b_index == moving_node_index):
				b = agent_b.target_position.global_position
			edge.override_scale = (a - b).length()
		
		i+=1
	#compute_area(positions[0], positions[1], positions[2])

func compute_area(a : Vector2, b: Vector2, c: Vector2):
	var new_area = abs(a.x * (b.y - c.y) + b.x * (c.y - a.y) + c.x * (a.y - b.y))/2.0
	if new_area != field_area:
		compute_damage_reduction()
		area_changed.emit(new_area, damage_reduction)
		field_area = new_area
	#print("area: " + str(area))

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
