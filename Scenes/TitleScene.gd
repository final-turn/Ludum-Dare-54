extends Control

@onready var video : VideoStreamPlayer = $"VideoStreamPlayer"
@onready var play_button : VideoStreamPlayer = $"Button Video"

func _ready():
	get_tree().paused = false
	video.finished.connect(on_end)
	play_button.finished.connect(on_button_end)

func on_end():
	video.play()
	
func on_button_end():
	play_button.play()

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/GameScene.tscn")
	
func goto_title():
	get_tree().change_scene_to_file("res://Scenes/TitleScene.tscn")
