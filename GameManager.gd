extends Node
class_name GameManager

@onready var resource_manager: ResourceManager = $"%ResourceManager"


func _ready():
	resource_manager.connect("population_changed", _check_win_lose_condition)


func _check_win_lose_condition():
	if ResourceManager.POPULATION > ResourceManager.MAX_POPULATION:
		get_tree().change_scene_to_file("res://scenes/lose_screen.tscn")
