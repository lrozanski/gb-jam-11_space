extends TileMap
class_name Map

signal building_built(building: String, tile_position: Vector2i)
signal building_removed(building: String)

static var SPRITE_SIZE: int = 16
static var TILE_SCALE: int = 4
static var TILE_SIZE: int = SPRITE_SIZE * TILE_SCALE

@export var pipe_scene: PackedScene = preload("res://buildings/pipe.tscn")
@export var habitat_scene: PackedScene = preload("res://buildings/habitat.tscn")
@export var farm_scene: PackedScene = preload("res://buildings/farm.tscn")
@export var air_filter_scene: PackedScene = preload("res://buildings/air_filter.tscn")
@export var landing_pad_scene: PackedScene = preload("res://buildings/landing_pad.tscn")

@onready var cursor: Cursor = $"%Cursor"
@onready var buildings: Buildings = $"%Buildings"
@onready var building_panel: BuildingPanel = $"%StatusBar/%BuildingPanel"
@onready var remove_building_panel: RemoveBuildingPanel = $"%StatusBar/%RemoveBuildingPanel"

func _ready():
	building_panel.connect("construction_confirmed", build_building)
	remove_building_panel.connect("removal_confirmed", remove_building)


func _get_cursor_tile_position():
	var local_map_position = to_local(global_position)
	return local_to_map(local_map_position)


func build_building(building_name: String):
	print("Built a %s" % building_name)
	
	match building_name:
		"H Pipe":
			var instance = pipe_scene.instantiate() as Pipe
			buildings.add_child(instance)
			
			instance.variant = Pipe.PipeVariant.HORIZONTAL
			instance.global_position = cursor.global_position
		"V Pipe":
			var instance = pipe_scene.instantiate() as Pipe
			buildings.add_child(instance)
			
			instance.variant = Pipe.PipeVariant.VERTICAL
			instance.global_position = cursor.global_position
		"Habitat":
			var instance = habitat_scene.instantiate() as Habitat
			instance.global_position = cursor.global_position
			buildings.add_child(instance)
		"Farm":
			var instance = farm_scene.instantiate() as Node2D
			instance.global_position = cursor.global_position
			buildings.add_child(instance)
		"Air Filter":
			var instance = air_filter_scene.instantiate() as Node2D
			instance.global_position = cursor.global_position
			buildings.add_child(instance)
		"Landing Pad":
			var instance = landing_pad_scene.instantiate() as Node2D
			instance.global_position = cursor.global_position
			buildings.add_child(instance)
	
	building_built.emit(building_name, _get_cursor_tile_position())


func remove_building():
	if !RemoveBuildingPanel.CHOICE:
		return
	
	var cursor_position = cursor.global_position
	var building = buildings.query_building(cursor_position, get_world_2d())
	
	if building != null:
		building_removed.emit(building.get_meta("type"))
		building.queue_free()
