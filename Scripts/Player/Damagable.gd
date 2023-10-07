class_name damagable extends Node

var mesh : MeshInstance3D
var base_color
var cooldown = 0

func _ready():
	mesh = get_parent()
	base_color = mesh.get_active_material(0).albedo_color

func _process(delta):
	if cooldown > 0:
		var lerped_color = lerp(base_color, Color(1, 0, 0, base_color.a), sin(cooldown * PI * 3))
		
		mesh.get_active_material(0).albedo_color = lerped_color
		
		cooldown -= delta
		if cooldown <= 0:
			mesh.get_active_material(0).albedo_color = base_color
			
	
func flash_damage(cooldownInterval : float):
	cooldown = cooldownInterval
