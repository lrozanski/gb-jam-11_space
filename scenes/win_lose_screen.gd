extends Node2D


func _process(_delta):
	if Input.is_action_just_pressed("Start"):
		get_tree().change_scene_to_file("res://scenes/main.tscn")
