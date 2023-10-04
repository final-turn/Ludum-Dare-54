extends Node3D

@export var president : President
@export var permimeter_manager : PerimeterManager
@export var agent_positions : ServicemanArray
@export var force_field : ForceField

@export var exp_per_second : float = 10.0/6.0
@export var exp_per_health : float = 10
@export var scaled_entities : Array[Node3D]

@onready var ui_manager = $"UI Manager"
@onready var audio_stream_player : AudioStreamPlayer = $"AudioStreamPlayer"

var max_time : float = 300
var time_remaining : float
var second_interval : float = 0
var experience : float = 0
var level = 1

var effect

func _ready():
	effect = AudioServer.get_bus_effect(1, 0)
	get_defense()
	time_remaining = max_time
	force_field.area_changed.connect(on_area_changed)
	president.on_health_update.connect(on_damage_taken)
	ui_manager.perk_selected.connect(on_perk_selected)
	agent_positions.agent_position_hovered.connect(on_serviceman_ui)

func _input(_event):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused

func on_damage_taken(_health, damage_taken):
	increase_exp(damage_taken * exp_per_health)	
	if _health <= 0:
		get_tree().change_scene_to_file("res://Scenes/GameOver.tscn")

func increase_exp(amount):
	experience += amount
	if experience >= 100:
		experience -= 100
		level = level + 1
		ui_manager.present_perks(level)
		get_tree().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	ui_manager.on_exp_update(experience)

func _process(delta):
	if !get_tree().paused:
		time_remaining -= delta
		ui_manager.update_timer(time_remaining)
		
		var experienceMultiplier =1
		second_interval += delta*experienceMultiplier
		if second_interval >= 1:
			second_interval-=1
			increase_exp(exp_per_second)
			
			var scaled_remaining = (max_time - time_remaining)/max_time
			audio_stream_player.pitch_scale = 1 + (scaled_remaining * 0.4)
			effect.pitch_scale = 1 - (scaled_remaining * .3)
			
			for n in scaled_entities:
				n.scaled_remaining = scaled_remaining
			
			if time_remaining <= 0:
				get_tree().change_scene_to_file("res://Scenes/Winning Scene.tscn")

func on_perk_selected(perk : PerkDefinition):
	var servman = permimeter_manager.get_child(perk.agent_affected)
	president._set_health(president.health + perk._increaseHealth)
	servman.defense += perk._increaseDefense
	servman.speed *= 1 + perk._increaseMovementSpeed
	servman.response_time *= 1 - perk._increaseReactionTime
	get_defense()
	get_tree().paused = false

func on_area_changed(_new_area, _new_reduction):
	ui_manager.update_shield_stats(force_field.damage_reduction, force_field.max_defense)

func get_defense():
	var max_defense = permimeter_manager._get_serviceman_defense()
	force_field.max_defense = max_defense
	force_field.compute_damage_reduction()
	ui_manager.update_shield_stats(force_field.damage_reduction, max_defense)

func on_serviceman_ui(is_shown, serviceman_position):
	var man = permimeter_manager.get_node(serviceman_position.name.substr(0, 12))
	if is_shown:
		ui_manager.show_agent_ui(man)
	else:
		ui_manager.hide_agent_ui()

