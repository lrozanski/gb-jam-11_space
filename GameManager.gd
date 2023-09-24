extends Node
class_name GameManager

@onready var resource_manager: ResourceManager = $"%ResourceManager"
@onready var map: TileMap = $"%TileMap"


func _ready():
	resource_manager.connect("population_changed", _check_lose_condition)
	map.connect("tile_terraformed", _check_victory_condition)


func _check_lose_condition():
	if (
		ResourceManager.POPULATION > ResourceManager.MAX_POPULATION
		|| ResourceManager.FOOD < 0
		|| ResourceManager.OXYGEN < 0
	):
		get_tree().change_scene_to_file("res://scenes/lose_screen.tscn")



func _is_tile_terraformed(tile_position: Vector2i):
	return map.get_cell_tile_data(0, tile_position).get_custom_data("is_terraformed") as bool


func _check_victory_condition():
	if map.get_used_cells(0).all(_is_tile_terraformed):
		get_tree().change_scene_to_file("res://scenes/victory_screen.tscn")


func pause():
	get_tree().paused = true


func unpause():
	get_tree().paused = false
