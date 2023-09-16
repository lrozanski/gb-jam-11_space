extends TileMap
class_name Map

static var SPRITE_SIZE: int = 16
static var TILE_SCALE: int = 4
static var TILE_SIZE: int = SPRITE_SIZE * TILE_SCALE

@export var pipe_scene: PackedScene = preload("res://buildings/pipe.tscn")

@onready var cursor: Cursor = $"%Cursor"
@onready var building_panel: BuildingPanel = $"%BuildingPanel"


func _ready():
	building_panel.connect("construction_confirmed", build_building)


func _process(delta):
	pass


func build_building():
	var building_name = BuildingPanel.BUILDING_NAME
	print("Built a %s" % building_name)
	
	match building_name:
		"Pipe":
			var pipe = pipe_scene.instantiate() as Node2D
			pipe.global_position = cursor.global_position
			get_tree().current_scene.add_child(pipe)
		"Habitat":
			pass
		"Farm Field":
			pass
		"Air Purifier":
			pass
		"Landing Pad":
			pass
