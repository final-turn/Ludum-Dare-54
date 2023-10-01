extends Node
class_name PerkDefinition

@export var _description = "enter description"
@export var _increaseDefense = 0
@export var _increaseHealth = 0
@export var _increaseReactionTime = 0.0
@export var _increaseMovementSpeed = 0.0

var agent_affected = -1
var formatted_description = ""

func assign_agent():
	agent_affected = randi_range(0,2)
	
func get_decription():
	formatted_description = _description
	formatted_description = formatted_description.replace("[AGENT]", ["Curly", "Larry"," Moe"][agent_affected])
	formatted_description = formatted_description.replace("[DEFENSE]", str(_increaseHealth*100) + "%")
	formatted_description = formatted_description.replace("[SPEED]", str(_increaseMovementSpeed*100) + "%")
	formatted_description = formatted_description.replace("[REACTION]", str(_increaseReactionTime*100) + "%")
	formatted_description = formatted_description.replace("[HEALTH]", str(_increaseHealth*100) + "%")
	
	return formatted_description
