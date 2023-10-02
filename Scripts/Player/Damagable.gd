class_name damagable extends Node

var mesh : MeshInstance3D
var color
var cooldownInterval = 0.1
var cooldown = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	mesh  =  get_parent()
	color = mesh.get_active_material(0).albedo_color
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("increaseExperienceSpeed"):
		flash_damage()
		
	if cooldown > 0:
		cooldown -= delta
		if cooldown <= 0:
			reset()
			
	pass
	
func flash_damage():
	mesh.get_active_material(0).albedo_color = Color(1, 0, 0, color.a)
	cooldown = cooldownInterval
	

func reset():
	mesh.get_active_material(0).albedo_color = color


