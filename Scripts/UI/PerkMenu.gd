extends Node


@export var perkManager : PerkManager

@export var perkButton1 : PerkButton
@export var perkButton2 : PerkButton
@export var perkButton3 : PerkButton
@export var heading : RichTextLabel

signal perk_selected # use this hook to recieve perk data

# Called when the node enters the scene tree for the first time.
func _ready():
	perkButton1.buttonPressed.connect(_on_perk_selected)
	perkButton2.buttonPressed.connect(_on_perk_selected)
	perkButton3.buttonPressed.connect(_on_perk_selected)
	_close()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_perk_selected(perk: PerkDefinition):
	print(perk.formatted_description)
	_close()
	emit_signal("perk_selected", perk)
	pass
	

func _close():
	self.visible = false

func _present_perks(level):
	perkManager.generate_perks()
	#heading.text = "LEVEL " +  str(level) + "!"
	perkButton1._set_perk(perkManager.get_perk(0))
	perkButton2._set_perk(perkManager.get_perk(1))
	perkButton3._set_perk(perkManager.get_perk(2))
	self.visible = true
