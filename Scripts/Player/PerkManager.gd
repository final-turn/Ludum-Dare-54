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
	random = allPerks.pick_random().duplicate()
	random.assign_agent(0)
	perks.append(random)
	random = allPerks.pick_random().duplicate()
	random.assign_agent(1)
	perks.append(random)
	random = allPerks.pick_random().duplicate()
	random.assign_agent(2)
	perks.append(random)
	#print("done")

func get_perk( index):
	return perks[index]


