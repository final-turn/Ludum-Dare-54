extends Node3D

func _on_area_3d_body_entered(body):
	#print(body.name)
	if body.name == "President":
		body.heal(20)
		queue_free()
