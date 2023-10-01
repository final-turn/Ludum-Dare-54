extends Node3D

@onready var ui_manager = $"UI Manager"
@onready var perk_menu = $"UI Manager/PerkMenu"

var time_remaining : float = 600
var perk_countdown : float = 15

func _ready():
	time_remaining = 600
	perk_menu.perk_selected.connect(on_perk_selected)

func _input(_event):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused

func _process(delta):
	if !get_tree().paused:
		time_remaining -= delta
		ui_manager.update_timer(time_remaining)
		
		perk_countdown -= delta
		if perk_countdown <= 0:
			perk_menu._present_perks()
			perk_countdown = 30
			get_tree().paused = true

func on_perk_selected(perk : PerkDefinition):
	get_tree().paused = false
