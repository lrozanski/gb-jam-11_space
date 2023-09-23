extends "res://buildings/Building.gd"
class_name Terraformer

@export var radius: int = 2

@onready var event_bus: EventBus = $"/root/Scene/%EventBus"


func _ready():
	connect("activated", _activated)
	connect("deactivated", _deactivated)


func _activated(_a, _b):
	event_bus.register_action_per_tick(_terraform_random_tile)

func _deactivated(_a, _b):
	event_bus.deregister_action_per_tick(_terraform_random_tile)


func _get_tiles_in_range():	
	var tile_position = get_tile_position()
	var all_cells: Array[Vector2i] = []

	for y in range(-radius, radius + 1):
		for x in range(-radius, radius + 1):
			var cell = Vector2i(tile_position.x + x, tile_position.y + y)

			if map.get_cell_source_id(0, cell) == -1:
				continue
			if map.get_cell_tile_data(0, cell).get_custom_data("is_terraformed"):
				continue
			
			all_cells.append(cell)
	
	return all_cells


func _distance_to(a: Vector2i, b: Vector2i):
	return abs(a.x - b.x) + abs(a.y - b.y)


func _terraform_random_tile():
	var tile_position = get_tile_position()
	var cells = _get_tiles_in_range()
	
	if cells.size() == 0:
		return
	
	cells.sort_custom(func(a: Vector2i, b: Vector2i): return _distance_to(a, tile_position) < _distance_to(b, tile_position))	
	map.terraform_tile(cells[0])
