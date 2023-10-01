extends Node3D

@export var exp_per_second : float = 10.0/6.0
@export var exp_per_health : float = 10

@onready var president : President = $"President"
@onready var ui_manager = $"UI Manager"
@onready var perk_menu = $"UI Manager/PerkMenu"
@onready var force_field = $"Force Field"
@onready var permimeter_manager = $"Perimeter Manager"

var time_remaining : float = 600
var second_interval : float = 0
var exp : float = 0

func _ready():
	get_defense()
	time_remaining = 600
	force_field.area_changed.connect(on_area_changed)
	perk_menu.perk_selected.connect(on_perk_selected)

func _input(_event):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused

func on_damage_taken(damage_taken):
	increase_exp(damage_taken * exp_per_health)

func increase_exp(amount):
	exp += amount
	if exp >= 100:
		exp -= 100
		perk_menu._present_perks()
		get_tree().paused = true
		
	ui_manager.on_exp_update(exp)

func _process(delta):
	if !get_tree().paused:
		time_remaining -= delta
		ui_manager.update_timer(time_remaining)
		
		second_interval += delta
		if second_interval >= 1:
			second_interval-=1
			increase_exp(exp_per_second)

func on_perk_selected(perk : PerkDefinition):
	get_tree().paused = false

func on_area_changed(_new_area, _new_reduction):
	ui_manager.update_shield_stats(force_field.damage_reduction, force_field.max_defense)

func get_defense():
	var max_defense = permimeter_manager._get_serviceman_defense()
	force_field.max_defense = max_defense
	ui_manager.update_shield_stats(force_field.damage_reduction, max_defense)
