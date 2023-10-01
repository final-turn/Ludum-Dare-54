extends Node

class_name PerkManager

var perks : Array[PerkDefinition]


func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _get_random_perk():
	for N in get_children():
		var child : PerkDefinition = N
		perks.append(child)
		
	return perks.pick_random()


