extends Node3D

@export var president : President
@export var agent_positions : ServicemanArray

@export var exp_per_second : float = 30
@export var exp_per_health : float = 10
@export var scaled_entities : Array[Node3D]

@onready var ui_manager = $"UI Manager"
@onready var audio_stream_player : AudioStreamPlayer = $"AudioStreamPlayer"
@onready var game_over = $"Game Over"
@onready var timer = $"Game Over/Timer"
@onready var win_screen = $"Win Screen"

var max_time : float = 300
var time_remaining : float
var second_interval : float = 0
var experience : float = 0
var level = 1

var effect

func _ready():
	effect = AudioServer.get_bus_effect(1, 0)
	time_remaining = max_time
	president.on_health_update.connect(on_damage_taken)
	ui_manager.perk_selected.connect(on_perk_selected)

func _input(_event):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused
		print(" is paused" if get_tree().paused else "not paused")

func on_damage_taken(_health, damage_taken):
	increase_exp(damage_taken * exp_per_health)	
	if _health <= 0:
		get_tree().paused = true
		update_timer(max_time - time_remaining)
		game_over.show()

func update_timer(amount : float):
	var minutes = floori(amount /60.0)
	var seconds = "%02d" % floori(amount - (minutes * 60))
	var ms = "%02d" % floori((amount - floorf(amount)) * 100)
	timer.text = ("You lasted %02d" % minutes) + ":" + seconds + "." + ms

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
	
		if time_remaining <= 0:
			time_remaining = 0
			get_tree().paused = true
			win_screen.show()
				
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
			

func on_perk_selected(perk : PerkDefinition):
	var servman = agent_positions.get_child(perk.agent_affected).get_child(0)
	president._set_health(president.health + perk._increaseHealth)
	servman.defense += perk._increaseDefense
	servman.speed += perk._increaseMovementSpeed
	servman.response_time -= perk._increaseReactionTime
	servman.increase_dive(perk.increase_dive)
	get_tree().paused = false
