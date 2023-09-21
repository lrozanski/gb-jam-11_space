extends Node2D
class_name BaseManager

@onready var map: Map = $"%TileMap"
@onready var buildings: Buildings = $"%Buildings"

var enabled_buildings: Array[Building] = []
var disabled_buildings: Array[Building] = []

var font: FontFile
var process = false

func _ready():
	map.connect("building_built", func(_a, _b): process = true, CONNECT_DEFERRED)
	map.connect("building_removed", func(_a, _b): process = true, CONNECT_DEFERRED)
	
	font = ThemeDB.fallback_font


func _tile_to_global(tile_position: Vector2i):
	var map_local = map.map_to_local(tile_position)
	return map.to_global(map_local)


func _on_building_built(_building_name: String = "", _tile_position: Vector2i = Vector2i.ZERO):
	if !process:
		process = true
		return
	
	process = false

	if get_tree().get_nodes_in_group("hq").size() == 0:
		return
	
	enabled_buildings.clear()
	disabled_buildings.clear()
	
	var tree = get_tree()
	var hq: Building = tree.get_first_node_in_group("hq") as Building
	var updated: Array[Vector2i] = hq.update_connections(hq.get_tile_position(), true)
	updated.insert(0, hq.get_tile_position())
	var all_buildings = tree.get_nodes_in_group("buildings")
	
	for item in all_buildings:
		if !is_instance_valid(item):
			continue

		var building = item as Building
		
		if not building.get_tile_position() in updated:
				building.disable_building()
				disabled_buildings.append(building)
		else:
			building.enable_building()
			enabled_buildings.append(building)
	
	print("Updated building state. Enabled: %s" % updated.size())
	print("Max population: %s" % ResourceManager.MAX_POPULATION)
	queue_redraw()


func _physics_process(_delta):
	if process:
		_on_building_built()
