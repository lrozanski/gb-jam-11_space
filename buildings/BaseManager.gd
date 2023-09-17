extends Node
class_name BaseManager

@onready var map: Map = $"%TileMap"
@onready var buildings: Buildings = $"%Buildings"


func _ready():
	map.connect("building_built", _on_building_built)


func _tile_to_global(tile_position: Vector2i):
	var map_local = map.map_to_local(tile_position)
	return map.to_global(map_local)


func _on_building_built(building_name: String, tile_position: Vector2i):
	if building_name != "Pipe":
		return
	
	var pipe = buildings.query_building(_tile_to_global(tile_position)) as Pipe
	
	var neighbouring_buildings = [
		buildings.query_building(_tile_to_global(tile_position + Vector2i(1, 0))),
		buildings.query_building(_tile_to_global(tile_position + Vector2i(-1, 0))),
	] if pipe.variant == Pipe.PipeVariant.HORIZONTAL else [
		buildings.query_building(_tile_to_global(tile_position + Vector2i(1, 0))),
		buildings.query_building(_tile_to_global(tile_position + Vector2i(-1, 0))),
	]
