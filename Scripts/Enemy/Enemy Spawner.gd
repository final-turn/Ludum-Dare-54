extends Node3D

@export var spawn_time : float = 5

@onready var president : President = $"../President"

var enemy_list : Array = []
var time_elapsed : float = 0
var rng : RandomNumberGenerator

func _ready():
	rng = RandomNumberGenerator.new()
	enemy_list.push_back(preload("res://Entities/missle.tscn"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_elapsed += delta
	
	if time_elapsed > spawn_time:
		time_elapsed = 0
		var new_enemy = enemy_list[rng.randi_range(0, enemy_list.size() - 1)].instantiate()
		var offset = Vector3(rng.randf_range(10,20), 0, rng.randf_range(10,20))
		new_enemy.global_position = president.global_position + offset
		new_enemy.president = president
		add_child(new_enemy)
