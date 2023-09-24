extends Node
class_name AudioManager

@onready var map: TileMap = $"%TileMap"
@onready var building_panel: BuildingPanel = $"%StatusBar/%BuildingPanel"

func _ready():
	map.connect("building_built", _on_building_built)
	map.connect("building_removed", _on_building_removed)
	building_panel.connect("cursor_moved", _on_menu_cursor_moved)
	building_panel.connect("cannot_build", _on_invalid_placement)


func _on_building_built(_a, _b):
	Jukebox.building_built_player.play()


func _on_building_removed(_a, _b):
	Jukebox.building_removed_player.play()


func _on_menu_cursor_moved():
	Jukebox.menu_sound_player.play()


func _on_invalid_placement():
	Jukebox.invalid_sound_player.play()
