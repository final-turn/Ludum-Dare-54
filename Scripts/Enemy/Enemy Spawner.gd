extends Node3D

@export var president : President
@export var spawn_time : float = 5
@export var scaled_remaining : float = 0

var enemy_list : Array = []
var time_elapsed : float = 0
var rng : RandomNumberGenerator
var game_manager

# Called when the node enters the scene tree for the first time.
func _ready():
	game_manager = get_parent_node_3d()
	rng = RandomNumberGenerator.new()
	enemy_list.push_back(preload("res://Entities/Enemies/small_missle.tscn"))
	enemy_list.push_back(preload("res://Entities/Enemies/mid_missle.tscn"))
	enemy_list.push_back(preload("res://Entities/Enemies/big_missle.tscn"))

func _process(delta):
	time_elapsed += delta
	spawn_time = 5 - 4 * scaled_remaining
	
	if time_elapsed > spawn_time:
		time_elapsed = 0
		var scale = min(enemy_list.size() - 1, floori(enemy_list.size() * scaled_remaining))
		var new_enemy = enemy_list[rng.randi_range(0,scale )].instantiate()
		var offset = Vector3(rng.randf_range(30,50), 0, rng.randf_range(30,50))
		var rot = rng.randf_range(0, 2*PI)
		offset = Vector3(cos(rot) * offset.x, 0, sin(rot) * offset.z)
		new_enemy.president = president
		add_child(new_enemy)
		new_enemy.global_position = president.position + offset
