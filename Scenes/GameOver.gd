extends Control

func goto_game():
	get_tree().change_scene_to_file("res://Scenes/GameScene.tscn")

func goto_title():
	get_tree().change_scene_to_file("res://Scenes/TitleScene.tscn")
