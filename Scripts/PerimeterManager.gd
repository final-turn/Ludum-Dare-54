extends Node3D

@onready var camera = $"../Camera Position"
@export var camera_distance = 9.7

var perimeter_servicemen : Array[Serviceman]

# Called when the node enters the scene tree for the first time.
func _ready():
	for N in get_children():
		var serviceman : Serviceman = N
		perimeter_servicemen.append(serviceman)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var default_set : bool = false
	var mins : Vector2 
	var maxs : Vector2
	for serviceman in perimeter_servicemen:
		if not default_set:
			mins = Vector2(serviceman.global_position.x, serviceman.global_position.z)
			maxs = Vector2(serviceman.global_position.x, serviceman.global_position.z)
			default_set = true
		else:
			if serviceman.global_position.x < mins.x:
				mins.x = serviceman.global_position.x
			elif serviceman.global_position.x > maxs.x:
				maxs.x = serviceman.global_position.x
			
			if serviceman.global_position.z < mins.y:
				mins.y = serviceman.global_position.z
			elif serviceman.global_position.z > maxs.y:
				maxs.y = serviceman.global_position.z
	
	var camera_x = (mins.x + maxs.x) / 2.0
	var camera_z = (mins.y + maxs.y) / 2.0
	camera.global_position = Vector3(camera_x, 0, camera_z + camera_distance)
	
