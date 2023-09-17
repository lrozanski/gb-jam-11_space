extends TileMap
class_name Map

static var SPRITE_SIZE: int = 16
static var TILE_SCALE: int = 4
static var TILE_SIZE: int = SPRITE_SIZE * TILE_SCALE

@export var pipe_scene: PackedScene = preload("res://buildings/pipe.tscn")
@export var habitat_scene: PackedScene = preload("res://buildings/habitat.tscn")
@export var farm_scene: PackedScene = preload("res://buildings/farm.tscn")
@export var air_filter_scene: PackedScene = preload("res://buildings/air_filter.tscn")
@export var landing_pad_scene: PackedScene = preload("res://buildings/landing_pad.tscn")

@onready var cursor: Cursor = $"%Cursor"
@onready var building_panel: BuildingPanel = $"%StatusBar/%BuildingPanel"


func _ready():
	building_panel.connect("construction_confirmed", build_building)


func build_building():
	var building_name = BuildingPanel.BUILDING_NAME
	print("Built a %s" % building_name)
	
	match building_name:
		"Pipe":
			var instance = pipe_scene.instantiate() as Node2D
			instance.global_position = cursor.global_position
			get_tree().current_scene.add_child(instance)
		"Habitat":
			var instance = habitat_scene.instantiate() as Node2D
			instance.global_position = cursor.global_position
			get_tree().current_scene.add_child(instance)
		"Farm":
			var instance = farm_scene.instantiate() as Node2D
			instance.global_position = cursor.global_position
			get_tree().current_scene.add_child(instance)
		"Air Filter":
			var instance = air_filter_scene.instantiate() as Node2D
			instance.global_position = cursor.global_position
			get_tree().current_scene.add_child(instance)
		"Landing Pad":
			var instance = landing_pad_scene.instantiate() as Node2D
			instance.global_position = cursor.global_position
			get_tree().current_scene.add_child(instance)
