class_name ServicemanArray extends Node3D

@export var target : Node3D

var perimeter_nodes : Array[ServicemanPosition]
var held_node : ServicemanPosition
var space_state
var camera

signal agent_position_hovered(is_shown, serviceman_position)

func _ready():
	camera = get_tree().root.get_camera_3d()
	space_state = get_world_3d().direct_space_state
	
	for N in get_children():
		var child : ServicemanPosition = N
		child.node_held.connect(on_node_held)
		child.on_hover.connect(on_position_hover)
		perimeter_nodes.append(child)

func on_mouse_world_position(pos):
	if held_node != null:
		#print("Holding " + str(held_node) + " at " + str(pos))
		held_node.position = Vector3(pos.x, 0, pos.z)

func on_node_held(target, is_held):
	held_node = target if is_held else null

func _physics_process(delta):
	global_position = target.global_position
	if held_node != null:
		var pos = screen_to_world()
		print(pos)
		held_node.position = Vector3(pos.x, 0, pos.z)

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

func on_position_hover(ref, is_hovered):
	agent_position_hovered.emit(ref, is_hovered)
