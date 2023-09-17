extends Node2D
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
	
	var world2d = get_world_2d()
	var pipe = Buildings.query_building(_tile_to_global(tile_position), world2d) as Pipe
	
	var neighbouring_buildings = [
		buildings.query_building(_tile_to_global(tile_position + Vector2i(1, 0)), world2d),
		buildings.query_building(_tile_to_global(tile_position + Vector2i(-1, 0)), world2d),
	] if pipe.variant == Pipe.PipeVariant.HORIZONTAL else [
		buildings.query_building(_tile_to_global(tile_position + Vector2i(1, 0)), world2d),
		buildings.query_building(_tile_to_global(tile_position + Vector2i(-1, 0)), world2d),
	]
