extends Node

class_name PerkManager

var agent_names = ["Agent 1","Agent 2","Agent 3"]
var perks : Array[PerkDefinition]

func generate_perks():
	var allPerks : Array[PerkDefinition] = []
	for N in get_children():
		var child : PerkDefinition = N
		allPerks.append(child)
		
	perks.clear()
	var random
	random = allPerks.pick_random()
	random.assign_agent()
	perks.append(random)
	random = allPerks.pick_random()
	random.assign_agent()
	perks.append(random)
	random = allPerks.pick_random()
	random.assign_agent()
	perks.append(random)

func get_perk( index):
	return perks[index]


