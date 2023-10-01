extends Node

class_name PerkButton

@export var label : Label
@export var button : Button
var perk : PerkDefinition
signal perkSelected
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	print("Button Pressed")
	emit_signal("perkSelected")


func _set_perk(newPerk):
	perk = newPerk
	label.text = perk._descriptiom
