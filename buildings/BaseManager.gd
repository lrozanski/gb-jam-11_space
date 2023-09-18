extends Node2D
class_name BaseManager

@onready var map: Map = $"%TileMap"
@onready var buildings: Buildings = $"%Buildings"
@onready var timer: Timer = $"Timer"

var enabled_buildings: Array[Building] = []
var disabled_buildings: Array[Building] = []


var font: FontFile
var process = false
var process_params = {}

func _ready():
	#map.connect("building_built", _on_building_built, CONNECT_DEFERRED)
	map.connect("building_built", _on_timeout)
	map.connect("building_removed", _on_timeout)
	timer.connect("timeout", _on_building_built)
	
	font = ThemeDB.fallback_font


func _on_timeout(_building_name: String = "", _tile_position: Vector2i = Vector2i.ZERO):
	timer.start()


func _tile_to_global(tile_position: Vector2i):
	var map_local = map.map_to_local(tile_position)
	return map.to_global(map_local)


# FIXME: Investigate this!
# FIXME: This has a bug that occurs for some connections, but not others
func _on_building_built():
	# if !process:
	# 	process = true
	# 	process_params = {
	# 		"building_name": building_name,
	# 		"tile_position": tile_position
	# 	}
	# 	return
	
	# process = false
	
	enabled_buildings.clear()
	disabled_buildings.clear()
	
	var hq: Building = get_tree().get_first_node_in_group("hq") as Building
	var updated: Array[Vector2i] = hq.update_connections(hq.get_tile_position(), true)
	updated.insert(0, hq.get_tile_position())
	var all_buildings = get_tree().get_nodes_in_group("buildings")
	
	for item in all_buildings:
		var building = item as Building
		
		if not building.get_tile_position() in updated:
			building.disable_building()
			disabled_buildings.append(building)
		else:
			building.enable_building()
			enabled_buildings.append(building)
	
	print("Updated building state. Enabled: %d" % updated.size())
	queue_redraw()


# func _process(_delta):
# 	if process:
# 		_on_building_built(process_params.get("building_name"), process_params.get("tile_position"))
# 		process = false
# 		process_params = {}


func _draw():
	var i = 0
	for building in enabled_buildings:
		var rect = Rect2(building.global_position, Vector2(Map.TILE_SIZE, Map.TILE_SIZE))
		draw_rect(rect, Color.WHITE, false, 4.0)
		draw_string(font, rect.get_center(), "%s" % i)
		i+=1
		
	for building in disabled_buildings:
		var rect = Rect2(building.global_position, Vector2(Map.TILE_SIZE, Map.TILE_SIZE))
		draw_rect(rect, Color.BLACK, false, 4.0)
	
