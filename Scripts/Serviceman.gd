class_name Serviceman extends Node3D

var target : Node3D

func _ready():
	target = get_node("/root/Game Scene/President/Serviceman Array/" + name + " Position")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	global_position = target.global_position - Vector3(0, 0.7, 0)
