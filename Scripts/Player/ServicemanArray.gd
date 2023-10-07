class_name ServicemanArray extends Node3D

@export var target : Node3D

signal agent_position_hovered(is_shown, serviceman)

@onready var force_field : ForceField = $"../Force Field"

var held_node : ServicemanPosition
var space_state
var camera

var agents : Array[Serviceman]
var agent_positions : Array[ServicemanPosition]

var president

func _ready():
	camera = get_tree().root.get_camera_3d()
	space_state = get_world_3d().direct_space_state
	
	var i = 0
	for child in get_children():
		var target_position : ServicemanPosition = child.get_node("Target Position")
		target_position.node_held.connect(on_node_held)
		target_position.on_hover.connect(on_position_hover)
		target_position.node_index = i
		agent_positions.append(target_position)
		agents.append(child.get_node("Serviceman"))
		i+=1

func on_node_held(t, is_held):
	if held_node != null:
		force_field.override_edge_label(held_node, is_held)
	held_node = t if is_held else null

func on_position_hover(ref, is_hovered):
	agent_position_hovered.emit(ref, is_hovered)

func on_mouse_world_position(pos):
	if held_node != null:
		#print("Holding " + str(held_node) + " at " + str(pos))
		held_node.position = Vector3(pos.x, 0, pos.z)

func _physics_process(_delta):
	global_position = target.global_position
	
	force_field.set_positions(agents)
	target.check_if_protected(agents)
	
	if held_node != null:
		var pos = screen_to_world()
		held_node.position = Vector3(pos.x, 0, pos.z)
		force_field.override_edge_label(held_node, true)

func screen_to_world():
	var mouse_position = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_position)
	var ray_end = ray_origin + camera.project_ray_normal(mouse_position) * 200
	
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end, 0x0001, [self])
	query.collide_with_areas = true
	query.collide_with_bodies = false
	var ray_array = space_state.intersect_ray(query)
	
	if(ray_array.has("position")):
		return ray_array["position"]
	return Vector3()

