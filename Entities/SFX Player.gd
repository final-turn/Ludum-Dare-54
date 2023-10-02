extends Node3D

@export var sound_list : Array[AudioStream]

@onready var stream_player : AudioStreamPlayer3D = $"AudioStreamPlayer3D"

var rng : RandomNumberGenerator

var time_elapsed : float  = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_elapsed += delta
	
	if time_elapsed > 10:
		time_elapsed -= 10
		#rng.randf_range(-1.0, 1.0)
		stream_player.stream = sound_list[rng.randi_range(0, sound_list.size() - 1)]
		stream_player.play()
