extends Node

class_name PerkButton

@export var label : Label
@export var button : Button
var perk : PerkDefinition
signal buttonPressed

func _on_button_pressed():
	emit_signal("buttonPressed", perk)


func _set_perk(newPerk):
	perk = newPerk
	label.text = perk.get_decription()
