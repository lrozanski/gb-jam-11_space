extends "res://buildings/Building.gd"
class_name Terraformer

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
	var cells = map.get_surrounding_cells(tile_position)
	var all_cells = {}

	for cell in cells:
		if map.get_cell_source_id(0, cell) == -1:
			continue
		all_cells[cell] = map.get_cell_tile_data(0, cell).get_custom_data("is_terraformed") as bool

		for cell2 in map.get_surrounding_cells(cell):
			if cell2 in all_cells:
				continue
			if map.get_cell_source_id(0, cell2) == -1:
				continue
			all_cells[cell2] = map.get_cell_tile_data(0, cell2).get_custom_data("is_terraformed") as bool

	return all_cells.keys().filter(func(key): return !all_cells[key])


func _distance_to(a: Vector2i, b: Vector2i):
	return abs(a.x - b.x) + abs(a.y - b.y)


func _terraform_random_tile():
	var tile_position = get_tile_position()
	var cells = _get_tiles_in_range()
	
	if cells.size() == 0:
		return
	
	cells.sort_custom(func(a: Vector2i, b: Vector2i): return _distance_to(a, tile_position) < _distance_to(b, tile_position))	
	map.terraform_tile(cells[0])
