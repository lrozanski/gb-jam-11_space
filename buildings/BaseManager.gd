extends Node2D
class_name BaseManager

@onready var map: Map = $"%TileMap"
@onready var buildings: Buildings = $"%Buildings"

var enabled_buildings: Array[Building] = []
var disabled_buildings: Array[Building] = []


var font: FontFile
var process = false
var process_params = {}

func _ready():
	map.connect("building_built", _on_building_built, CONNECT_DEFERRED)
	
	font = ThemeDB.fallback_font


func _tile_to_global(tile_position: Vector2i):
	var map_local = map.map_to_local(tile_position)
	return map.to_global(map_local)


func _on_building_built(building_name: String, tile_position: Vector2i):
	if !process:
		process = true
		process_params = {
			"building_name": building_name,
			"tile_position": tile_position
		}
		return
	
	process = false
	
	enabled_buildings.clear()
	disabled_buildings.clear()
	
	var hq: Building = get_tree().get_first_node_in_group("hq") as Building
	var updated: Array[Vector2i] = hq.update_connections(hq.get_tile_position(), true)
	updated.insert(0, hq.get_tile_position())
	var buildings = get_tree().get_nodes_in_group("buildings")
	
	for item in buildings:
		var building = item as Building
		
		if not building.get_tile_position() in updated:
			building.disabled = true
			disabled_buildings.append(building)
		else:
			building.disabled = false
			enabled_buildings.append(building)
	
	print("Updated building state. Enabled: %d" % updated.size())
	queue_redraw()


func _process(delta):
	if process:
		_on_building_built(process_params.get("building_name"), process_params.get("tile_position"))
		process = false
		process_params = {}


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
	
