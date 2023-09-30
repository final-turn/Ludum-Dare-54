extends Node

@export var perkButton1 : PerkButton
@export var perkButton2 : PerkButton
@export var perkButton3 : PerkButton
# Called when the node enters the scene tree for the first time.
func _ready():
	perkButton1.perkSelected.connect(_on_perk1_selected)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_perk1_selected():
	print("perk 1")
	pass
	
