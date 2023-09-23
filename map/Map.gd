extends TileMap
class_name Map

signal building_built(building: String, tile_position: Vector2i)
signal building_removed(building: String, disabled: bool)
signal hq_placed()

static var SPRITE_SIZE: int = 16
static var TILE_SCALE: int = 4
static var TILE_SIZE: int = SPRITE_SIZE * TILE_SCALE

@export_category("Building Prefabs")
@export var hq_scene: PackedScene = preload("res://buildings/hq.tscn")
@export var pipe_scene: PackedScene = preload("res://buildings/pipe.tscn")
@export var habitat_scene: PackedScene = preload("res://buildings/habitat.tscn")
@export var farm_scene: PackedScene = preload("res://buildings/farm.tscn")
@export var air_filter_scene: PackedScene = preload("res://buildings/air_filter.tscn")
@export var mine_scene: PackedScene = preload("res://buildings/mine.tscn")
@export var terraformer_scene: PackedScene = preload("res://buildings/terraformer.tscn")
@export var landing_pad_scene: PackedScene = preload("res://buildings/landing_pad.tscn")

@export_category("Map Generation")
@export var noise: FastNoiseLite

@onready var cursor: Cursor = $"%Cursor"
@onready var buildings: Buildings = $"%Buildings"
@onready var building_panel: BuildingPanel = $"%StatusBar/%BuildingPanel"
@onready var remove_building_panel: RemoveBuildingPanel = $"%StatusBar/%RemoveBuildingPanel"
@onready var resource_manager: ResourceManager = $"%ResourceManager"
@onready var event_bus: EventBus = $"%EventBus"

var BLANK_TILE_COORDS = Vector2i(7, 7)
var VALUE_TO_TILE_ID = {
	[0.45, 0.55]: Vector2i(3, 1),
	[0.65, 0.75]: Vector2i(4, 1),
	[0.85, 0.95]: Vector2i(5, 1),
}

var patch_pattern = [
	Vector2i(0, 3),
	Vector2i(1, 3),
	Vector2i(0, 4),
	Vector2i(1, 4),
]

var tile_coords_to_terraformed_tile_coords = {
	Vector2i(7, 7): Vector2i(7, 0),
	Vector2i(0, 3): Vector2i(0, 5),
	Vector2i(1, 3): Vector2i(1, 5),
	Vector2i(0, 4): Vector2i(0, 6),
	Vector2i(1, 4): Vector2i(1, 6),
	Vector2i(3, 1): Vector2i(0, 1),
	Vector2i(4, 1): Vector2i(1, 1),
	Vector2i(5, 1): Vector2i(2, 1),
}


func _ready():
	building_panel.connect("construction_confirmed", build_building)
	remove_building_panel.connect("removal_confirmed", remove_building)
	connect("hq_placed", event_bus.start_game)

	_generate_map()


func _get_cursor_tile_position():
	var local_map_position = to_local(global_position)
	return local_to_map(local_map_position)


func build_building(building_name: String):
	print("Built a %s" % building_name)
	
	match building_name:
		"HQ":
			var instance = hq_scene.instantiate() as Habitat
			buildings.add_child(instance)

			instance.global_position = cursor.global_position
			hq_placed.emit()

			_terraform_in_range(cursor.get_tile_position(), 2)
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
		"Mine":
			var instance = mine_scene.instantiate() as Node2D
			instance.global_position = cursor.global_position
			buildings.add_child(instance)
		"Terraformer":
			var instance = terraformer_scene.instantiate() as Terraformer
			instance.global_position = cursor.global_position
			buildings.add_child(instance)
		"Landing Pad":
			var instance = landing_pad_scene.instantiate() as LandingPad
			instance.global_position = cursor.global_position
			buildings.add_child(instance)
	
	var iron_cost = buildings.BUILDING_COST[building_name]
	resource_manager.update_iron(-iron_cost)
	building_built.emit(building_name, _get_cursor_tile_position())


func remove_building(remove: bool):
	if !remove:
		return
	
	var cursor_position = cursor.global_position
	var building = Buildings.query_building(cursor_position, get_world_2d())
	
	if building != null:
		var iron_cost = buildings.BUILDING_COST[building.building_type]
		resource_manager.update_iron(iron_cost)
		building_removed.emit(building.building_type, building.disabled)
		building.queue_free()


func _generate_map():
	noise.seed = randi()

	for y in range(1, 8):
		for x in range(10):
			var cell_position = Vector2i(x, y)
			var value = (noise.get_noise_2dv(cell_position * Map.TILE_SIZE) + 1) / 2.0
			var tile_coords = BLANK_TILE_COORDS
			var keys = VALUE_TO_TILE_ID.keys()

			value = clampf(value, 0.0, 1.0)

			for value_range in keys:
				var min_value = value_range[0]
				var max_value = value_range[1]

				if value >= min_value && value <= max_value:
					tile_coords = VALUE_TO_TILE_ID[value_range]
					break

			set_cell(0, cell_position, 0, tile_coords)
	
	for i in range(randi_range(1, 2)):
		var tile_position = Vector2i(
			randi_range(0, 9),
			randi_range(1, 6),
		)
		set_cell(0, tile_position, 0, patch_pattern[0])
		set_cell(0, tile_position + Vector2i(1, 0), 0, patch_pattern[1])
		set_cell(0, tile_position + Vector2i(0, 1), 0, patch_pattern[2])
		set_cell(0, tile_position + Vector2i(1, 1), 0, patch_pattern[3])


func terraform_tile(tile_position: Vector2i):
	var tile_source_id = get_cell_source_id(0, tile_position)
	if tile_source_id == -1:
		return

	var tile_data = get_cell_tile_data(0, tile_position)
	var is_terraformed = tile_data.get_custom_data("is_terraformed") as bool
	var atlas_coords = get_cell_atlas_coords(0, tile_position)

	if is_terraformed:
		return
	
	var new_tile_coords = tile_coords_to_terraformed_tile_coords[atlas_coords]
	set_cell(0, tile_position, 0, new_tile_coords)


func _terraform_in_range(tile_position: Vector2i, tile_range: int):
	for y in range(-tile_range, tile_range + 1):
		for x in range(-tile_range, tile_range + 1):
			var distance_squared = tile_position.y - (tile_position.y + y) * tile_position.x - (tile_position.x + x)
			
			if distance_squared >= tile_range * tile_range:
				continue
				
			var new_tile_position = tile_position + Vector2i(x, y)
			terraform_tile(new_tile_position)
