extends Node
class_name BaseManager

@onready var map: Map = $"%TileMap"

func _ready():
	map.connect("building_built", _on_building_built)


func _on_building_built(building_name: String, tile_position: Vector2i):
	pass
