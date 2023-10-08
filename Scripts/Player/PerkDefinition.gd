extends Node
class_name PerkDefinition

@export var _description = "enter description"
@export var _increaseDefense = 0
@export var _increaseHealth = 0
@export var _increaseReactionTime = 0.0
@export var _increaseMovementSpeed = 0.0
@export var increase_dive = 0.0

var agent_affected = -1
var formatted_description = ""

func assign_agent(agent):
	agent_affected = agent #randi_range(0,2)
	#print("assign_agent: " + str(agent))
	
func get_decription():
	#print("affects: " + str(agent_affected))
	formatted_description = _description
	formatted_description = formatted_description.replace("[AGENT]", ["Curly", "Larry"," Moe"][agent_affected])
	formatted_description = formatted_description.replace("[DEFENSE]", str(_increaseDefense))
	formatted_description = formatted_description.replace("[SPEED]", str(_increaseMovementSpeed))
	formatted_description = formatted_description.replace("[REACTION]", str(_increaseReactionTime))
	formatted_description = formatted_description.replace("[HEALTH]", str(_increaseHealth))
	formatted_description = formatted_description.replace("[DIVE]", str(increase_dive))
	
	return formatted_description
