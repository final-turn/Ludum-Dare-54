extends Node3D

@export var spawn_time : float = 5

@onready var president : President = $"../President"

var enemy_list : Array = []
var time_elapsed : float = 0
var rng : RandomNumberGenerator

func _ready():
	rng = RandomNumberGenerator.new()
	enemy_list.push_back(preload("res://Entities/Enemies/small_missle.tscn"))
	enemy_list.push_back(preload("res://Entities/Enemies/mid_missle.tscn"))
	enemy_list.push_back(preload("res://Entities/Enemies/big_missle.tscn"))

func _process(delta):
	time_elapsed += delta
	
	if time_elapsed > spawn_time:
		time_elapsed = 0
		var new_enemy = enemy_list[rng.randi_range(0, enemy_list.size() - 1)].instantiate()
		var offset = Vector3(rng.randf_range(10,20), 0, rng.randf_range(10,20))
		var rot = rng.randf_range(0, PI)
		offset = Vector3(cos(rot) * offset.x, 0, sin(rot) * offset.z)
		new_enemy.president = president
		add_child(new_enemy)
		new_enemy.global_position = president.position + offset
