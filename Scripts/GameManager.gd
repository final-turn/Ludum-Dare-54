extends Node3D

@onready var ui_manager = $"UI Manager"

var time_remaining : float = 600

func _ready():
	time_remaining = 600

func _input(_event):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused

func _process(delta):
	if !get_tree().paused:
		time_remaining -= delta
		ui_manager.update_timer(time_remaining)
