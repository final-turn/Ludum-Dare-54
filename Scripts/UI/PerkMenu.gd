extends Node


@export var perkManager : PerkManager

@export var perkButton1 : PerkButton
@export var perkButton2 : PerkButton
@export var perkButton3 : PerkButton

# Called when the node enters the scene tree for the first time.
func _ready():
	perkButton1.perkSelected.connect(_on_perk1_selected)
	perkButton2.perkSelected.connect(_on_perk2_selected)
	perkButton3.perkSelected.connect(_on_perk3_selected)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_perk1_selected():
	print("perk 1")
	_close()
	pass
	
	
func _on_perk2_selected():
	print("perk 2")
	_close()
	pass
	
	
func _on_perk3_selected():
	print("perk 3")
	_close()
	pass
	

func _close():
	self.visible = false


func _present_perks():
	perkButton1._set_perk(perkManager._get_random_perk())
	perkButton2._set_perk(perkManager._get_random_perk())
	perkButton3._set_perk(perkManager._get_random_perk())
	self.visible = true
	pass # Replace with function body.
