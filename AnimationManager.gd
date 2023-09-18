extends Node


@onready var map: TileMap = $"%TileMap"
@onready var cursor: Cursor = $"%Cursor"


func _ready():
	map.connect("building_built", _on_building_built, CONNECT_DEFERRED)
	map.connect("building_removed", _on_building_removed, CONNECT_DEFERRED)


func _on_building_built(_building_name: String, _tile_position: Vector2i):
	_update_global_animations()


func _on_building_removed(_building_name: String):
	_update_global_animations()


func _update_global_animations():
	var buildings = get_tree().get_nodes_in_group("buildings")

	for item in buildings:
		var building = item as Building

		if building.disabled:
			building.restart_animations()
	
	cursor.restart_animation()

