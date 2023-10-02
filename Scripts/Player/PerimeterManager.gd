extends Node3D
class_name PerimeterManager

@export var camera_distance = 9.7

@onready var force_field : ForceField = $"../Force Field"

var perimeter_servicemen : Array[Serviceman]

# Called when the node enters the scene tree for the first time.
func _ready():
	for N in get_children():
		var serviceman : Serviceman = N
		perimeter_servicemen.append(serviceman)

func _get_serviceman_defense():
	var defense = 0
	for serviceman in get_children():
		defense += serviceman.defense
	return defense

func _physics_process(_delta):
	var positions : Array[Vector3] = []
	for child in get_children():
		positions.push_back(child.global_position)
	force_field.set_positions(positions)
