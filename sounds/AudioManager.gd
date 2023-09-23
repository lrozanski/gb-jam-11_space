extends Node
class_name AudioManager

@onready var map: TileMap = $"%TileMap"
@onready var building_panel: BuildingPanel = $"%StatusBar/%BuildingPanel"

@onready var building_built_stream: AudioStreamPlayer = $"building_built"
@onready var building_removed_stream: AudioStreamPlayer = $"building_removed"
@onready var menu_sound_stream: AudioStreamPlayer = $"menu"
@onready var invalid_sound_stream: AudioStreamPlayer = $"invalid"


func _ready():
	map.connect("building_built", _on_building_built)
	map.connect("building_removed", _on_building_removed)
	building_panel.connect("cursor_moved", _on_menu_cursor_moved)
	building_panel.connect("cannot_build", _on_invalid_placement)


func _on_building_built(_a, _b):
	building_built_stream.play()


func _on_building_removed(_a, _b):
	building_removed_stream.play()


func _on_menu_cursor_moved():
	menu_sound_stream.play()


func _on_invalid_placement():
	invalid_sound_stream.play()
